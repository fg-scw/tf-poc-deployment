// Variables for staging environment
// Common variables
variable "tests_staging_core" {
  type = map(string)

  default = {
    production = false
    //env name
    env_name = "tests-staging"
    //conditional deployments
    // Main zone
    main_zone = "fr-par-1"
    // Backup zone
    backup_zone = "fr-par-2"

    deploy_db = true
    // Name for the S3 bucket
    bucket_name         = "tests-staging-bucket"
    glacier_bucket_name = "tests-staging-bucket-glacier"
    // Can be "free" or "premium"
    cockpit_plan = "free"
  }
}

variable "tags" {
  default = ["tests-staging", "terraform", "iac"]
}

// Network variables
variable "tests_staging_network" {
  type = map(string)

  default = {
    // CIDR to use, at least /22 for Kapsule
    network_private_cidr = "172.16.200.0/22"
    // Type of the Public Gateway
    network_pgw_type = "VPC-GW-S"
    // SSH bastion on Public Gateway
    network_pgw_enable_bastion = true
  }
}

// DB variables
variable "tests_staging_bdd" {
  type = map(string)

  default = {
    db_node_type = "db-play2-pico"
    // Username for db, Password is auto generated
    db_admin_name = "dga_staging_admin"
    // Disk size for the DB in Gb
    db_disk_size = 50
    // Do we need HA or not
    db_is_ha = false
    // Do we need read replica or not
    db_enable_read_replica = false
    // Do we need backup or not
    db_disable_backup = false
    // Frequency in hours
    db_backup_frequency = 24
    // Retention in days
    db_backup_retention = 7
    // Do we need a public endpoint
    db_disable_public_endpoint = true
  }
}

// Kube Variables
variable "tests_staging_kube" {
  type = map(string)

  default = {
    // Config for the cluster
    // Type of the control plane, can "kapsule", "kapsule-dedicated-4", "kapsule-dedicated-8" or "kapsule-dedicated-16".
    cluster_type = "kapsule"
    // Kubernetes version
    kapsule_version = "1.29.1"
    // Warning modifying this will recreate the cluster
    cni = "cilium"

    // Config for the first pool
    // Instance type
    cluster_pool_0_node_type = "PLAY2-MICRO"
    // Disk size for node, in Go
    cluster_pool_0_disk_size = 20
    // Min number of instances
    cluster_pool_0_min_size = 2
    // Max number of instances
    cluster_pool_0_max_size = 4

    // Config for the second pool
    // Do we need a second pool
    deploy_backup_pool = false
    // Instance type
    cluster_pool_1_node_type = "PLAY2-NANO"
    // Disk size for node, in Go
    cluster_pool_1_disk_size = 20
    // Min number of instances
    cluster_pool_1_min_size = 1
    // Max number of instances
    cluster_pool_1_max_size = 4

    // Do we need cert manager
    deploy_cert_manager = true
    // Version for cert manager
    cert_manager_version = "v1.13.3"

    // Do we need external secret
    deploy_external_secret = true
    // Version for external secret
    external_secret_version = "v0.9.11"

    // Do we need ingress controller
    deploy_ingress_nginx = true

    // Ip to whitelist
    allowed_cidr = "['0.0.0.0/0']"
  }
}
