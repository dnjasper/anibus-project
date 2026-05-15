output "dev_ecr_url" {
  value       = module.vpc.ecr_repository_url
  description = "The live ECR registry URL for our dev environment applications"
}
