// Call the DB module
module "database" {
  count = var.param_core.deploy_db ? 1 : 0
  // Path to the module
  source = "../database/"

  env_name = var.param_core.env_name

  // Id of the project created for this env
  project_id = scaleway_account_project.project.id
  // Id of the private network created for this env
  pn_id = scaleway_vpc_private_network.pn.id

  //Arguments for DB
  db_param = var.param_db
  tags     = var.tags
}
