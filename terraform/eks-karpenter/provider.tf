terraform {
  //backend "s3" {
  //  bucket         = "terraform-terragrunt-states"
  //  region         = "us-east-1"
  //  dynamodb_table = "terraform_lock_db"
  //  key            = "eks-dev.tfstate" 
  //}

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }            
  }
}