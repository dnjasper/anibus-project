# VPC Variables
variable "project_name" {
  description = "project name"
  type        = string
  default     = "idontknow"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
}


variable "private_data_subnet_az1_cidr" {
  type        = string
  description = "The CIDR block for private data subnet AZ1"
}

variable "private_data_subnet_az2_cidr" {
  type        = string
  description = "The CIDR block for private data subnet AZ2"
}

variable "public_subnet_az1_cidr" {          
  description = "public subnet az1 cidr block"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "public subnet az2 cidr block"
  type        = string
}

variable "private_subnet_az1_cidr" {
  description = "private app subnet az1 cidr block"
  type        = string
}

variable "private_subnet_az2_cidr" {
  description = "private app subnet az2 cidr block"
  type        = string
}

variable "environment" {
  description = "dev/stage"
  type        = string
}

