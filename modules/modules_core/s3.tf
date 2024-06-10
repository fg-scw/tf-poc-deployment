// Create an S3 bucket
resource "scaleway_object_bucket" "tests_bucket" {
  name       = var.param_core.bucket_name
  project_id = scaleway_account_project.project.id
  //tags = var.tags
}

// Create the second bucket for Glacier
resource "scaleway_object_bucket" "tests_glacier_bucket" {
  count      = var.param_core.production ? 1 : 0
  name       = var.param_core.glacier_bucket_name
  project_id = scaleway_account_project.project.id
  //tags = var.tags
}
