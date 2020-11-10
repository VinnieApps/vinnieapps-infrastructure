terraform {
  required_version = "0.13.5"
  backend "gcs" {
    credentials = "../../../credentials.json"
    prefix  = "01-base"
  }
}
