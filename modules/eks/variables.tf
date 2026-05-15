variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "ec2_instance_type" {
  description = "instance size"
  type        = string
}


variable "environment" {
  type        = string
  description = "The target deployment context name"
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}


variable "subnet_ids" {
  description = "private subnet ids for worker nodes"
  type        = list(string)
}



variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs for the EKS cluster"
}

