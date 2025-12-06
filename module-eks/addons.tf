# Get EKS authentication token
data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

# Kubernetes provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

# Helm provider
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Install NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  values     = [file("${path.module}/nginx-ingress-values.yaml")]
  depends_on = [aws_eks_node_group.eks_node_group]
}

# Get the Load Balancer from the nginx-ingress Service
data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.nginx_ingress]
}

# Output the LB hostname
output "nginx_ingress_lb_hostname" {
  value = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}

# Install cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.14.5"
  namespace        = "cert-manager"
  create_namespace = true

  set = [{
    name  = "installCRDs"
    value = "true"
  }]

  depends_on = [helm_release.nginx_ingress]
}

# Install ArgoCD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true

  values     = [file("${path.module}/argocd-values.yaml")]
  depends_on = [helm_release.nginx_ingress, helm_release.cert_manager]
}
