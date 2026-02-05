############################################
# Terraform & Provider (SAFE VERSIONS)
############################################

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

############################################
# Provider
############################################

provider "aws" {
  region = "ap-south-1"
}

############################################
# VPC
############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "trend-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-south-1a", "ap-south-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false
}

############################################
# EKS (STABLE v19 SYNTAX)
############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "trend-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }
}

