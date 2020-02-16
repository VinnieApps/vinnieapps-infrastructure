variable "db_name" {
  description = "Database name."
}

variable "namespace" {
  description = "Namespace to create the dataase in."
}

variable "node_count" {
  description = "Number of instaces to be replicated in the stateful set."
  default = 3
}

variable "volume_size" {
  description = "Size to be used for the volume that will be created."
  default = "10Gi"
}
