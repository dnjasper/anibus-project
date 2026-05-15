module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

   name = "${var.cluster_name}-cluster"
   kubernetes_version = "1.31"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids 

  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  endpoint_public_access = true

  # vpc_id = aws_vpc.vpc.id

  #subnet_ids = var.subnet_ids

  # # subnet_ids = [
  # #   aws_subnet.private_subnet_az1.id,
  # #   aws_subnet.private_subnet_az2.id
  # # ]

  # control_plane_subnet_ids = [
  #   aws_subnet.public_subnet_az1.id,
  #   aws_subnet.public_subnet_az2.id
  # ]

  addons = {
    vpc-cni = {
      before_compute = true
    }

    eks-pod-identity-agent = {
      before_compute = true
    }

    coredns = {}

    kube-proxy = {}
  }

  eks_managed_node_groups = {
    anubis = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      capacity_type = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      labels = {
        role = "general"
      }

      tags = {
        Name = "anubis-node-group"
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}