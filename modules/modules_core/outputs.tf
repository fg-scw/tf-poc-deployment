output "project_id" {
  description = "Id of the new project"
  value       = scaleway_account_project.project.id
}

output "container_registry_endpoint" {
  description = "Endpoint for the container registry"
  value       = scaleway_registry_namespace.container-registry.endpoint
}
