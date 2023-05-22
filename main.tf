# CONFIGURE GCP PROVIDERS
provider "google" {
  credentials = file("credentials.json")
  project = var.project_id
  region  = var.region
  zone = var.zone
}

# IAM CONFIGURATION
module "billing-account-iam" {
  source  = "terraform-google-modules/iam/google//modules/billing_accounts_iam"
  billing_account_ids = var.billing_account_ids

  mode = var.billing_accounts_iam_mode
  bindings = var.billing_accounts_iam_bindings
}

module "cloud-run-services-iam-bindings" {
  source             = "terraform-google-modules/iam/google//modules/cloud_run_services_iam"
  project            = var.project_id
  cloud_run_services = var.cloud_run_services_iam_bindings_services
  mode               = var.cloud_run_services_iam_bindings_mode

  bindings = var.cloud_run_services_iam_bindings
}

module "artifact-registry-repository-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/artifact_registry_iam"
  project      = var.project_id
  repositories = var.artifact_registry_iam_bindings_repositories
  location     = var.location
  mode         = var.artifact_registry_iam_bindings_mode

  bindings = var.artifact_registry_iam_bindings
}

module "storage_buckets_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "~> 8.0"

  storage_buckets = var.storage_buckets_iam_bindings_buckets

  mode = var.storage_buckets_iam_bindings_mode

  bindings = var.storage_buckets_iam_bindings
}

# ARTIFACT REGISTRY
resource "google_artifact_registry_repository" "api-repo" {
  location      = var.location
  repository_id = var.artifact_registry_repository_id
  description   = "Docker repository for API"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}

# CLOUD STORAGE
# module "gcs_buckets" {
#   source  = "terraform-google-modules/cloud-storage/google"
#   version = "~> 4.0"
#   project_id  = var.project_id
#   names = var.gcs_buckets_names
#   prefix = "my-unique-prefix"
#   set_admin_roles = true
#   admins = var.cloud_storage_admins
#   versioning = {
#     first = false
#   }
#   bucket_admins = {
#     second = "user:spam@example.com,eggs@example.com"
#   }
# }

module "bucket" {
  source = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"

  name       = "${var.project_id}-bucket"
  project_id = var.project_id
  location   = var.location

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age            = 365
      with_state     = "ANY"
      matches_prefix = var.project_id
    }
  }]

  # custom_placement_config = {
  #   data_locations : ["US-EAST4", "US-WEST1"]
  # }

  iam_members = var.bucket_iam_members
}

# CLOUD SQL

# CLOUD RUN SERVICES
module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.2.0"

  # Required variables
  service_name           = var.cloud_run_services_name
  project_id             = var.project_id
  location               = var.location
  image                  = var.cloud_run_image
}