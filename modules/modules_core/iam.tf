// Create full access group
resource "scaleway_iam_group" "iam_group_full_access" {
  name        = "${var.param_core.env_name}-full-access"
  description = "This is full access"
  tags        = var.tags
}

// Create full access policy
resource "scaleway_iam_policy" "policy_full_access" {
  name     = "${var.param_core.env_name}-full-access"
  group_id = scaleway_iam_group.iam_group_full_access.id
  rule {
    // Id of the project we give rights for
    project_ids = [scaleway_account_project.project.id]
    // The right we give
    permission_set_names = ["AllProductsFullAccess"]
  }
  tags = var.tags
}

// Create read only group
resource "scaleway_iam_group" "iam_group_read_only" {
  name        = "${var.param_core.env_name}-read-only"
  description = "This is read only"
  tags        = var.tags
}

// Create read only policy
resource "scaleway_iam_policy" "policy_read_only" {
  name     = "${var.param_core.env_name}-read-only"
  group_id = scaleway_iam_group.iam_group_read_only.id
  rule {
    // Id of the project we give rights for
    project_ids = [scaleway_account_project.project.id]
    // The right we give
    permission_set_names = ["AllProductsReadOnly"]
  }
  tags = var.tags
}
