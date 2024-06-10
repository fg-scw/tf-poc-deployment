resource "scaleway_k8s_cluster" "k8s_cluster" {
  project_id                  = var.project_id
  name                        = var.env_name
  type                        = var.kube_param.cluster_type
  version                     = var.kube_param.kapsule_version
  cni                         = var.kube_param.cni
  private_network_id          = var.private_network.id
  delete_additional_resources = true
  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "10m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }
  tags = var.tags
}

resource "scaleway_instance_security_group" "k8s_pool_0_sg" {
  project_id              = var.project_id
  zone                    = var.main_zone
  name                    = "${var.env_name}-kube-pool-0-sg"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  stateful                = true
  depends_on              = [scaleway_k8s_cluster.k8s_cluster]
  tags                    = var.tags
}

resource "scaleway_instance_placement_group" "k8s_pool_0_placement_group" {
  project_id  = var.project_id
  zone        = var.main_zone
  name        = "${var.env_name}-kube-pool-0-placement-group"
  policy_type = "max_availability" # spread accross hypervisor to increase resilience
  policy_mode = "optional"         # don't block adding new nodes if constraint can't be managed
  tags        = ["kapsule", var.env_name]
}


resource "scaleway_k8s_pool" "k8s_pool_0" {
  zone                   = var.main_zone
  cluster_id             = scaleway_k8s_cluster.k8s_cluster.id
  name                   = "${var.env_name}-kube-pool-0"
  node_type              = var.kube_param.cluster_pool_0_node_type
  root_volume_size_in_gb = var.kube_param.cluster_pool_0_disk_size
  size                   = var.kube_param.cluster_pool_0_min_size
  min_size               = var.kube_param.cluster_pool_0_min_size
  max_size               = var.kube_param.cluster_pool_0_max_size
  autoscaling            = true
  autohealing            = true
  wait_for_pool_ready    = true
  container_runtime      = "containerd"
  placement_group_id     = scaleway_instance_placement_group.k8s_pool_0_placement_group.id
  depends_on             = [scaleway_instance_placement_group.k8s_pool_0_placement_group]
  tags                   = var.tags
}

resource "scaleway_instance_security_group" "k8s_pool_1_sg" {
  project_id              = var.project_id
  zone                    = var.backup_zone
  name                    = "${var.env_name}-kube-pool-1-sg"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  stateful                = true
  depends_on              = [scaleway_k8s_cluster.k8s_cluster]
  tags                    = var.tags
}

resource "scaleway_instance_placement_group" "k8s_pool_1_placement_group" {
  project_id  = var.project_id
  zone        = var.backup_zone
  name        = "${var.env_name}-kube-pool-1-placement-group"
  policy_type = "max_availability" # spread accross hypervisor to increase resilience
  policy_mode = "optional"         # don't block adding new nodes if constraint can't be managed
  tags        = var.tags
}

resource "scaleway_k8s_pool" "k8s_pool_1" {
  count                  = var.kube_param.deploy_backup_pool ? 1 : 0
  zone                   = var.backup_zone
  cluster_id             = scaleway_k8s_cluster.k8s_cluster.id
  name                   = "${var.env_name}-kube-pool-1"
  node_type              = var.kube_param.cluster_pool_1_node_type
  root_volume_size_in_gb = var.kube_param.cluster_pool_1_disk_size
  size                   = var.kube_param.cluster_pool_1_min_size
  min_size               = var.kube_param.cluster_pool_1_min_size
  max_size               = var.kube_param.cluster_pool_1_max_size
  autoscaling            = true
  autohealing            = true
  wait_for_pool_ready    = true
  container_runtime      = "containerd"
  placement_group_id     = scaleway_instance_placement_group.k8s_pool_1_placement_group.id
  depends_on             = [scaleway_instance_placement_group.k8s_pool_1_placement_group]
  tags                   = var.tags
}
