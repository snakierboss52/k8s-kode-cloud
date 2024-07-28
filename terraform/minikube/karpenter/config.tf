provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # Just for minikube
  }
}

resource "helm_release" "argocd" {
 name  = "argocd"
 repository = "https://argoproj.github.io/argo-helm"
 chart = "argo-cd"
 namespace = "argocd"
 create_namespace = true
 version = "7.3.11"
}


# kubectl port-forward svc/argocd-server -n argocd 8080:80
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# argocd admin initial-password -n argocd