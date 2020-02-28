terraform {
  backend "gcs" {
    credentials = file("../credentials.json")
    prefix  = "03-applications"
  }
}
