provider "aws" {
  region = "us-east-1"
}


# ----------------------------
# IAM Roles existants (LabRole)
# ----------------------------
data "aws_iam_role" "master" {
  name = "LabRole"
}

data "aws_iam_role" "worker" {
  name = "LabRole"
}

# ----------------------------
# VPC
# ----------------------------
data "aws_vpc" "main" {
  id = "vpc-0d3780d4d45cab53c"
}

# ----------------------------
# Subnets (Sélectionnés pour la haute disponibilité)
# ----------------------------
data "aws_subnet" "subnet-1" {
  id = "subnet-0cfb1dd5b72c4e94d" # Zone us-east-1a
}

data "aws_subnet" "subnet-2" {
  id = "subnet-0788f44548be4a6bd" # Zone us-east-1b
}

# ----------------------------
# Security Group
# ----------------------------
data "aws_security_group" "selected" {
  id = "sg-0df9d13dd1e841420" # Ton Lab-SG
}

# ----------------------------
# EKS Cluster
# ----------------------------
resource "aws_eks_cluster" "eks" {
  name     = "MelCluster"
  role_arn = data.aws_iam_role.master.arn

  vpc_config {
    subnet_ids         = [data.aws_subnet.subnet-1.id, data.aws_subnet.subnet-2.id]
    security_group_ids = [data.aws_security_group.selected.id]
  }

  tags = {
    Name        = "MelCluster"
    Environment = "dev"
    Terraform   = "true"
  }
}

# ----------------------------
# EKS Node Group
# ----------------------------
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name
  node_role_arn   = data.aws_iam_role.worker.arn
  subnet_ids      = [data.aws_subnet.subnet-1.id, data.aws_subnet.subnet-2.id]
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = ["t2.large"]

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 2
  }

  tags = {
    Name = "lab-eks-node-group"
  }
}

# ----------------------------
# OIDC Provider pour ServiceAccount IAM Roles
# ----------------------------
data "aws_eks_cluster" "eks_oidc" {
  name = aws_eks_cluster.eks.name
}

data "tls_certificate" "oidc_thumbprint" {
  url = data.aws_eks_cluster.eks_oidc.identity[0].oidc[0].issuer
}

