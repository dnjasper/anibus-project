# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public az1"

    # This tells AWS: "Use this subnet for internal-only Load Balancers"
    "kubernetes.io/role/internal-elb" = "1"
    # This links the subnet to your specific cluster
    "kubernetes.io/cluster/my-cluster" = "shared"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public az2"

    # This tells AWS: "Use this subnet for internal-only Load Balancers"
    "kubernetes.io/role/internal-elb" = "1"
    # This links the subnet to your specific cluster
    "kubernetes.io/cluster/my-cluster" = "shared"
  }
}


# create PRIVATE subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]


  tags = {
    Name = "${var.project_name}-${var.environment}-private-az1"

    # This tells AWS: "Use this subnet for internal-only Load Balancers"
    "kubernetes.io/role/internal-elb" = "1"
    # This links the subnet to your specific cluster
    "kubernetes.io/cluster/my-cluster" = "shared"
  }
}

# create PRIVATE subnet az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]


  tags = {
    Name = "${var.project_name}-${var.environment}-private-az2"

    # This tells AWS: "Use this subnet for internal-only Load Balancers"
    "kubernetes.io/role/internal-elb" = "1"
    # This links the subnet to your specific cluster
    "kubernetes.io/cluster/my-cluster" = "shared"

  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# associate PUBLIC subnet az1 to "PUBLIC route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate PUBLIC subnet az2 to "PUBLIC route table"
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}



# create route table and add private route
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.anubis.id  
  # }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt"
  }
}

# Resource - depends_on_ Meta-Argument
resource "aws_eip" "eks-workers" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-eip"
  }

}

# Create NAT Gateway for Private Subnets

resource "aws_nat_gateway" "anubis" {
  depends_on    = [aws_internet_gateway.internet_gateway]
  allocation_id = aws_eip.eks-workers.id
  #subnet_id     = aws_subnet.anubis.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gateway"
  }

}
resource "aws_route" "route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.anubis.id
}


# associate PRIVATE subnet az1 to "PRIVATE route table"
resource "aws_route_table_association" "private_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

# associate PRIVATE subnet az2 to "PRIVATE route table"
resource "aws_route_table_association" "private_subnet_2_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

# # create private app subnet az1
# resource "aws_subnet" "private_app_subnet_az1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.private_app_subnet_az1_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[0]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.project_name}-${var.environment}-private-app-az1"
#   }
# }

# # create private app subnet az2
# resource "aws_subnet" "private_app_subnet_az2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.private_app_subnet_az2_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[1]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.project_name}-${var.environment}-private-app-az2"
#   }
# }

# # create private data subnet az1
# resource "aws_subnet" "private_data_subnet_az1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.private_data_subnet_az1_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[0]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.project_name}-${var.environment}-private-data-az1"
#   }
# }

# # create private data subnet az2
# resource "aws_subnet" "private_data_subnet_az2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.private_data_subnet_az2_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[1]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.project_name}-${var.environment}-private-data-az2"
#   }
# }
  