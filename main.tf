
resource "random_string" "random_id" {
  length           = 4
  upper            = false
  numeric          = false
  special          = false
}

resource "google_project" "notebook-project" {
  name       = "notebook-project-${random_string.random_id.result}"
  project_id = "notebook-project-${random_string.random_id.result}"
  billing_account = "${var.billing_id}"
  # uncomment the following line to assign to an organization
  # org_id     = "1234567" 
}

/*
# The following code can be used to create a project in a folder

resource "google_project" "my_project-in-a-folder" {
  name       = "My Project"
  project_id = "your-project-id"
  folder_id  = google_folder.department1.name
}

resource "google_folder" "department1" {
  display_name = "Department 1"
  parent       = "organizations/1234567"
}
*/


# create a notebook instance
resource "google_project_service" "notebooks" {
  provider           = google
  project            = google_project.notebook-project.project_id
  service            = "notebooks.googleapis.com"
  disable_on_destroy = false
}

resource "google_notebooks_instance" "basic_instance" {
  project      = google_project.notebook-project.project_id
  name         = "notebooks-instance-basic"
  provider     = google
  # requires a zone, not a region 
  location     = "us-central1-a" 
  machine_type = "e2-small"

  # The project here is the project where the image is stored,
  # not the project where the instance is created
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-ent-2-9-cu113-notebooks"
  }

  depends_on = [
    google_project_service.notebooks
  ]
}



resource "google_project_service" "google-cloud-apis" {
  project = google_project.notebook-project.project_id 
  for_each = toset([
    "aiplatform.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "notebooks.googleapis.com"
  ])
  disable_dependent_services = true
  disable_on_destroy         = true
  service                    = each.key
}



resource "google_project_iam_member" "vertexai_user" {
  project = google_project.notebook-project.project_id 
  for_each = toset([
    "roles/aiplatform.user",
    "roles/aiplatform.admin",
    "roles/ml.admin",
  ])

  role   = each.key
  member = "user:${var.vertexai_user_email}"
  depends_on = [
    google_project_service.google-cloud-apis
  ]
}
