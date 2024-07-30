data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
  depends_on = [ module.eks ]
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
  depends_on = [ module.eks ]
}