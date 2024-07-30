module "eks" {
  depends_on = [ module.vpc ]
  source  = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  cluster_name                   = "eks-dev-cluster"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.micro"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size     = 0
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"

      tags = {
        name = "dev-cluster"
      }
    }
  }

  tags = {
        name = "dev-cluster"
    }
}