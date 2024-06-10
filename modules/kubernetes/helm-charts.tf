// Helm Chart that will be used to create Cert Manager Resources
resource "helm_release" "cert_manager" {
  count = var.kube_param.deploy_cert_manager ? 1 : 0
  name  = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.kube_param.cert_manager_version
  namespace        = "cert-manager"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}

// Helm Chart that will be used to create External Secret Resources
resource "helm_release" "external_secret" {
  count = var.kube_param.deploy_external_secret ? 1 : 0
  name  = "external-secret"

  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.kube_param.external_secret_version
  namespace        = "external-secrets"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}
