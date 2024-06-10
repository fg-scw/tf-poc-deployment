// Create the Tests Staging environment
module "tests_staging" {
  source = "./modules/modules_core/"

  param_core    = var.tests_staging_core
  param_network = var.tests_staging_network
  param_db      = var.tests_staging_bdd
  param_kube    = var.tests_staging_kube
  tags          = var.tags
}

