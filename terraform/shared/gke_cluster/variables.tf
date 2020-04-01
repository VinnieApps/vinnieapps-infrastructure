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

variable "node_disk_size" {
  default     = "10"
  description = "Size of the boot volume for the nodes the pool"
}

variable "zone" {
  description = "Zone used to create the resources."
}
