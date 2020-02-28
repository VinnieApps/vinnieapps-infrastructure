terraform {
  backend "gcs" {
    credentials = file("../credentials.json")
    prefix  = "01-base"
  }
}
