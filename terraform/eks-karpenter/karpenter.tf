resource "aws_iam_role" "karpenter" {
    depends_on = [ module.eks ]
    name = "karpenter"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
        Effect = "Allow",
        Principal = {
            Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy" "karpenter_contoller" {
    name = "karpenter-policy"
    role = aws_iam_role.karpenter.name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = [
            "ec2:CreateLaunchTemplate",
            "ec2:CreateFleet",
            "ec2:RunInstances",
            "ec2:CreateTags",
            "iam:PassRole",
            "ec2:TerminateInstances",
            "ec2:DeleteLaunchTemplate",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeInstances",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeInstanceTypeOfferings",
            "ec2:DescribeAvailabilityZones",
            "ssm:GetParameter"
            ]
            Effect   = "Allow"
            Resource = "*"
        },
        ]
    })
}

data "aws_iam_policy" "ssm_managed_instance" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
    role       = aws_iam_role.karpenter.name
    policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_instance_profile" "karpenter" {
    name = "KarpenterNodeInstanceProfile-eks-dev-cluster"
    role = aws_iam_role.karpenter.name
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

# Install Karpenter via Helm chart
resource "helm_release" "karpenter" {
    depends_on = [module.eks, kubernetes_namespace.karpenter]
    name       = "karpenter"
    repository = "https://charts.karpenter.sh"
    chart      = "karpenter"
    version    = "0.16.3"
    namespace  = "karpenter"

    set {
        name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = aws_iam_role.karpenter.arn
    }

    set {
        name  = "clusterName"
        value = module.eks.cluster_name
    }

    set {
        name  = "clusterEndpoint"
        value = data.aws_eks_cluster.this.endpoint
    }

    set {
        name  = "controller.aws.defaultInstanceProfile"
        value = "KarpenterNodeInstanceProfile"
    }
}