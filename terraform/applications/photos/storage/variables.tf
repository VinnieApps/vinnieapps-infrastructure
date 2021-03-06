variable "environment" {
  description = "Name of the environment your building."
}

variable "region" {
  default = "us-east1"
  description = "Region where the environment is going to be created."
}

variable "zone" {
  default = "us-east1-b"
  description = "Zone used to create the resources."
}