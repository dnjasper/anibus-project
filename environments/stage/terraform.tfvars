# Generic Variables that Override other Variable Files

#Environment/stage/tfvars
region      = "us-east-1"
environment = "stage"
# business_division = "HR"
project_name = "anubis"

# VPC tfvars
vpc_cidr                = "10.0.0.0/16"
public_subnet_az1_cidr  = "10.0.0.0/24"
public_subnet_az2_cidr  = "10.0.1.0/24"
private_subnet_az1_cidr = "10.0.2.0/24"
private_subnet_az2_cidr = "10.0.3.0/24"

ssl_certificate_arn  = "arn:aws:acm:us-east-1:533267265715:certificate/6794abc5-662a-4152-9ce7-f188b057fb41"
operator_email       = "dnjasper@hotmail.com"
launch_template_name = "stage-launch-template"
ec2_image_id         = "ami-0ccbe661b0facf3a6"
ec2_instance_type    = "t3.medium" # Keep it cheap for stage
ec2_key_pair_name    = "terraform-key"
domain_name          = "yourdomain.com"
