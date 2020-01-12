variable "environment" {
  description = "Name of the environment your building."
}

variable "machine_type" {
  default     = "n1-standard-1"
  description = "Compute instance type for the main pool"
}

variable "node_code" {
  default     = 1
  description = "Number of nodes in the main pool"
}

variable "zone" {
  default = "us-east1-b"
  description = "Zone used to create the resources."
}
