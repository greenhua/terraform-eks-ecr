variable "eks_cluster_name" {
  default     = {
    "dev" = "tf_cluster"
  }
  type        = map
  description = "The name of the snapshot (if any) the database should be created from"
}

variable "instance_types" {
  default     = {
    "dev" = ["t2.small"]
  }
  type        = map
  description = "The name of the snapshot (if any) the database should be created from"
}

variable "node_group_name" {
  default     = {
    "dev" = "tf_cluster-group-1"
  }
  type        = map
  description = "The name of the snapshot (if any) the database should be created from"
}
