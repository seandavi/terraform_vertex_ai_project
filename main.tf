
resource "random_string" "random_id" {
  length           = 4
  upper            = false
  numeric          = false
  special          = false
}

resource "google_project" "vertex_ai-project" {
  name       = "vertex_ai-project-${random_string.random_id.result}"
  project_id = "vertex_ai-project-${random_string.random_id.result}"
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



resource "google_project_service" "google-cloud-apis" {
  project = google_project.vertex_ai-project.project_id 
  for_each = toset([
    "aiplatform.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "vertex_ais.googleapis.com"
  ])
  disable_dependent_services = true
  disable_on_destroy         = true
  service                    = each.key
}



resource "google_project_iam_member" "vertexai_user" {
  project = google_project.vertex_ai-project.project_id 
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
