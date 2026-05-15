# modules/vpc/outputs.tf

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the provisioned VPC"
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_az1.id,
    aws_subnet.private_subnet_az2.id
  ]
  description = "List of private subnet IDs for the EKS cluster"
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_az1.id,
    aws_subnet.public_subnet_az2.id
  ]
  description = "List of public subnet IDs for the EKS control plane"
}
