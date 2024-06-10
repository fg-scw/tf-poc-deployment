// Create the container registry
resource "scaleway_registry_namespace" "container-registry" {
  project_id  = scaleway_account_project.project.id
  name        = "${var.param_core.env_name}-container-registry"
  description = "Container registry for ${var.param_core.env_name}"
  is_public   = false
}
