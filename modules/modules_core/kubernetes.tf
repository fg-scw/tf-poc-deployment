module "kubernetes" {
  source = "../kubernetes/"

  env_name   = var.param_core.env_name
  kube_param = var.param_kube

  project_id      = scaleway_account_project.project.id
  private_network = scaleway_vpc_private_network.pn

  main_zone   = var.param_core.main_zone
  backup_zone = var.param_core.backup_zone
  tags        = var.tags
}
