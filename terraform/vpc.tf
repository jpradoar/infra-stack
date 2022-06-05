locals {
  # https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/
  kubernetes_vpn_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  kubernetes_subnets_tags = merge(
    local.kubernetes_vpn_tags,
    {
      "kubernetes.io/role/elb" = 1
  })
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name            = local.vpc_name
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = lookup(var.private_subnets, terraform.workspace) # var.private_subnets
  public_subnets  = lookup(var.public_subnets, terraform.workspace)  # var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az # We will enable one gateway per AZ.
  enable_dns_hostnames   = var.enable_dns_hostnames   # Needed for public access to RDS instances
  enable_dns_support     = var.enable_dns_support     # Needed for public access to RDS instances

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval    = var.flow_log_max_aggregation_interval

  tags = merge(
    local.common_tags,
    local.kubernetes_vpn_tags
  )

  public_subnet_tags = merge(
    local.kubernetes_subnets_tags,
    {
      tier = "Public"
    }
  )

  private_subnet_tags = merge(
    local.kubernetes_subnets_tags,
    {
      tier = "Private"
    }

  )

}



#---------------------- OUTPUTS -----------------------

output "vpc_data" {
  value = module.vpc.name
}
