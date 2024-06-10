terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.41.0"
    }
  }

  // State storage
  backend "s3" {
    // Change this.
    bucket = "tests-staging-terraform-s3state"
    // Path in the S3 bucket
    key = "tests/dev/terraform.tfstate"
    // Region of the bucket
    region = "fr-par"
    // Change the endpoint if we change the region
    endpoints                  = { s3 = "https://s3.fr-par.scw.cloud" }
    skip_requesting_account_id = true
    // Credentials of the user to use
    profile = "default"
    // Needed for SCW
    skip_credentials_validation = true
    skip_region_validation      = true
  }

  // Terraform version
  required_version = ">= 1.6.1"
}

provider "scaleway" {
  // AZ we want to use
  zone = "fr-par-1"
  // Region we want to use
  region = "fr-par"
  // Replace with customer organization id
  organization_id = "<YOUR ORGID>"
}
