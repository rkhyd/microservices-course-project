locals {
  ami_type               = "AL2_x86_64"
  azs                    = slice(data.aws.availability_zones.available.names, 0, 3)
  capacity_type          = "SPOT"
  cluster_version        = "1.29"
  disk_size              = 30
  enable_cluster_creator = true
  enable_nat_gateway     = true
  enable_public_access   = true
  instance_types         = ["t3.medium"]
  node_desired_size      = 3
  node_max_size          = 5
  node_min_size          = 1
  intra_subnets          = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  single_nat_gateway     = true
  vpc_cidr               = ["10.0.0.0/16"]
  vpc_name               = "microservices-course-project"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name = "${local.vpc_name}-vpc"
  cidr = local.vpc_cidr

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = local.single_nat_gateway


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}