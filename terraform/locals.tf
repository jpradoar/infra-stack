data "aws_caller_identity" "current" {
  provider = aws
}

locals {
  resources_name = "${var.product}-${var.client}-${var.environment}"

  vpc_name         = local.resources_name
  eks_cluster_name = local.resources_name
  rds_db_name      = local.resources_name
  ec2_name         = local.resources_name

  common_tags = {
    product     = var.product
    client      = var.client
    environment = var.environment
    terraform   = "true"
    git_tag     = var.git_tag
    # lastmodified = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp() ) # uncomment if you like to add datetime tag to your resources. (IMPORTANT: using this tag, could be possible that TF recreate some resources. )
  }

  account_id = data.aws_caller_identity.current.account_id
}
