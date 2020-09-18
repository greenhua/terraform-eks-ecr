provider "aws" {
  region     = "eu-west-1"
}
//

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "subnets_cidr" {
  type = "list"
  default = ["172.31.0.0/20", "172.31.32.0/20", "172.31.16.0/20"]
}

variable "azs" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

#terraform {
#  backend "s3" {
#    bucket = "my-tf-state"
#    key    = "states.tf"
#    region = "eu-west-1"
#  }
#}


