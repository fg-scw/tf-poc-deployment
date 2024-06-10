resource "scaleway_account_project" "project" {
  provider = scaleway
  name     = var.param_core.env_name
}

resource "scaleway_cockpit" "cockpit" {
  project_id = scaleway_account_project.project.id
  plan       = var.param_core.cockpit_plan
}
