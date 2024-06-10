//Reserved IP for the Load Balancer of the ingress
resource "scaleway_lb_ip" "nginx_ip" {
  project_id = var.project_id
}

// Helm Chart that will be used to create Nginx Ingress Resources
resource "helm_release" "ingress_nginx" {
  count = var.kube_param.deploy_ingress_nginx ? 1 : 0
  name  = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }

  //Associate the Load Balancer wiyth an IP (not required as if it is not specified) the controller will create a Flexible IP
  //But it can be useful if we want to keep/reserve the same IP
  set {
    name  = "controller.service.loadBalancerIP"
    value = scaleway_lb_ip.nginx_ip.ip_address
  }

  set {
    name  = "controller.config.whitelist-source-range"
    value = var.kube_param.allowed_cidr
  }

  // enable proxy protocol to get client ip addr instead of loadbalancer one
  set {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
    value = "true"
  }

  // indicates in which zone to create the loadbalancer
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
    value = var.main_zone
  }

  // enable to avoid node forwarding
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  // For cert-manager
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-use-hostname"
    value = "true"
  }
}
