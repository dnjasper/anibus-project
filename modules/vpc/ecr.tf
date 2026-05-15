resource "aws_ecr_repository" "anubis_api" {
  name                 = "anubis-api"
  image_tag_mutability = "MUTABLE"

  # 🔐 Security Scanner: Automatically inspects your Docker containers for threats on every push
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "anubis-api-registry"
    Environment = var.environment
  }
}

# 🔗 Export Gate: We must expose this repository URL so our automation pipeline can find it
output "ecr_repository_url" {
  value       = aws_ecr_repository.anubis_api.repository_url
  description = "The URL of our private ECR storage repository"
}
