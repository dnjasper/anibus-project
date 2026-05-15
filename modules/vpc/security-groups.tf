

# create security group for the app server
resource "aws_security_group" "eks_workers_security_group" {
  name        = "${var.project_name}-${var.environment}-eks-workers-server-sg"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-workers-server-sg"
  }
}

