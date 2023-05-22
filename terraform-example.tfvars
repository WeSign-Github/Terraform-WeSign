# MAIN PROVIDER CONFIGURATION
# This section use for addressing project and location
# for Cloud Provider : Google Cloud Platform (GCP)
# PROJECT
STATUS="development"
project_id="<project-id>"

# LOCATIONS
PORT="8000"
ZONE="asia-southeast2"
REGION="asia-southeast2"
LOCATION="asia-southeast2"

# IAM CONFIGURATION
# This section is use for all IAM accounts configuration.
# BILLING ACCOUNT
billing_account_iam_mode="additive"
billing_account_ids=["XXXXXX-XXXXXX-XXXXXX"]
billing_account_iam_bindings= {
    "roles/billing.viewer" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
    ]

    "roles/billing.user" = [
      "user:my-user@my-org.com",
    ]
  }

# CLOUD RUN SERVICES
cloud_run_services_iam_bindings_mode="authoritative"
cloud_run_services_iam_bindings_services=["my_cloud_run_service_one", "my_cloud_run_service_two"]
cloud_run_services_iam_bindings={
    "roles/run.invoker" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
    "roles/run.admin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
  }

# ARTIFACT REGISTRY REPOSITORY
artifact_registry_repository_iam_bindings_mode="additive"
artifact_registry_repository_iam_bindings_repositories=["my-project_one", "my-project_two"]
artifact_registry_repository_iam_bindings={
    "roles/compute.networkAdmin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
  }

# STORAGE BUCKETS
storage_buckets_iam_bindings_buckets=["my-storage-bucket"]
storage_buckets_iam_bindings_mode="authoritative"
storage_buckets_iam_bindings={
    "roles/storage.legacyBucketReader" = [
      "user:josemanuelt@google.com",
      "group:test_sa_group@lnescidev.com",
    ]

    "roles/storage.legacyBucketWriter" = [
      "user:josemanuelt@google.com",
      "group:test_sa_group@lnescidev.com",
    ]
  }

# INFRASTRUCTURE CONFIGURATION
#  This section is being use to address 
#  all cloud infrastructure being used in Google Cloud Platform.

# ARTIFACT REGISTRY 
#  To Create gcr.io or compiling image to be use in Google Cloud Run.
artifact_registry_repository_id="api-repo"

# CLOUD RUN
cloud_run_service_name="api-deployment"
cloud_run_image="gcr.io/cloudrun/api-deployment"

# STORAGE CONFIGURATION
# CLOUD STORAGE
# gcs_buckets_names=["public-bucket"]
# cloud_storage_admins=["group:foo-admins@example.com"]
# gcs_buckets_admins={}
bucket_iam_members=[{
    role   = "roles/storage.objectViewer"
    member = "group:test-gcp-ops@test.blueprints.joonix.net"
  }]

# CLOUD SQL


