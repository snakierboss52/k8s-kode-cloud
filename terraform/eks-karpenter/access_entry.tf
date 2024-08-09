#resource "aws_eks_access_entry" root {
#  cluster_name      = data.aws_eks_cluster.this.name
#  principal_arn     = "arn:aws:iam::986593220527:root"
#  type              = "STANDARD"
#}

#resource aws_eks_access_policy_association root {
#  cluster_name = data.aws_eks_cluster.this.name
#  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#  principal_arn = "arn:aws:iam::986593220527:root"

#access_scope {
#    type = "cluster"
#  }
  
#  depends_on = [aws_eks_access_entry.root]
#}