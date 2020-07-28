terraform {
  backend "gcs" {
    credentials = "../../../credentials.json"
    prefix  = "01-base"
  }
}
