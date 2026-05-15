# ==============================================================================
# 1. TERRAFORM VERSIONS & REMOTE STATE BACKEND
# ==============================================================================
terraform {
  required_version = "~> 1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44.0"
    }
  }

  # 🔒 Connects your local terminal to your remote S3 bucket storage
  backend "s3" {
    bucket         = "dnj-kube-project-tfstat" # 🛑 CHANGE to your actual S3 bucket name
    key            = "dev/infrastructure.tfstate"   # Isolates dev from stage
    region         = "us-east-1"                   # 🛑 CHANGE to your bucket's region if not us-east-1
    dynamodb_table = "terraform-lock-table"             # 🛑 CHANGE to your actual DynamoDB table name
    encrypt        = true
  }
}

# ==============================================================================
# 2. AWS PROVIDER CONFIGURATION
# ==============================================================================
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}

# ==============================================================================
# 3. ROOT VARIABLES (Instructs this folder to look for values in your tfvars file)
# ==============================================================================
variable "region"                       { type = string }
variable "project_name"                 { type = string }
variable "environment"                  { type = string }
variable "cluster_name"                 { type = string }
variable "vpc_cidr"                     { type = string }
variable "public_subnet_az1_cidr"       { type = string }
variable "public_subnet_az2_cidr"       { type = string }
variable "private_subnet_az1_cidr"      { type = string }
variable "private_subnet_az2_cidr"      { type = string }
variable "private_data_subnet_az1_cidr" { type = string }
variable "private_data_subnet_az2_cidr" { type = string }
variable "ssl_certificate_arn"          { type = string }
variable "operator_email"               { type = string }
variable "launch_template_name"         { type = string }
variable "ec2_image_id"                 { type = string }
variable "ec2_instance_type"            { type = string }
variable "ec2_key_pair_name"            { type = string }
variable "domain_name"                  { type = string }
#variable "alternative_names"            { type = string }

# ==============================================================================
# 4. MODULE RUNNER (Passes your live data down to the shared blueprint folder)
# ==============================================================================
module "infrastructure" {
  source = "../../modules/infrastructure_base"

  region                       = var.region
  project_name                 = var.project_name
  environment                  = var.environment
  cluster_name                 = var.cluster_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_subnet_az1_cidr      = var.private_subnet_az1_cidr
  private_subnet_az2_cidr      = var.private_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
  ssl_certificate_arn          = var.ssl_certificate_arn
  operator_email               = var.operator_email
 # launch_template_name         = var.launch_template_name
  ec2_image_id                 = var.ec2_image_id
  ec2_instance_type            = var.ec2_instance_type
  ec2_key_pair_name            = var.ec2_key_pair_name
  domain_name                  = var.domain_name
 # alternative_names            = var.alternative_names
}
