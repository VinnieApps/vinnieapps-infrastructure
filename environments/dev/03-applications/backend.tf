terraform {
  backend "gcs" {
    credentials = "../credentials.json"
    prefix  = "03-applications"
  }
}
