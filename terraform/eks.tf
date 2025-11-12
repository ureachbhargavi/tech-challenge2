module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      desired_size = var.desired_size
      min_size     = var.min_size
      max_size     = var.max_size
      instance_types = [var.instance_type]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "DevOpsTechChallenge"
  }
}
