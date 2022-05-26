module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.20.5"
  cluster_name    = local.eks_cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets


  #  aws_auth_roles = [
  #    {
  #      rolearn  = "arn:aws:iam::${local.account_id}:role/ReadOnly"
  #      username = "arn:aws:iam::${local.account_id}:role/ReadOnly"
  #      groups   = ["readonly"]
  #    },
  #    {
  #      rolearn  = "arn:aws:iam::${local.account_id}:role/FullAccess"
  #      username = "arn:aws:iam::${local.account_id}:role/FullAccess"
  #      groups   = ["fullaccess"]
  #    },
  #    {
  #      rolearn  = "arn:aws:iam::${local.account_id}:role/Administrator"
  #      username = "arn:aws:iam::${local.account_id}:role/Administrator"
  #      groups   = ["system:masters"]
  #    },
  #    {
  #      rolearn  = "arn:aws:iam::${local.account_id}:role/KubernetesAdministrator"
  #      username = "arn:aws:iam::${local.account_id}:role/KubernetesAdministrator"
  #      groups   = ["system:masters"]
  #    }
  #  ]

  eks_managed_node_group_defaults = {
    ami_type      = var.ami_type
    taints        = []
    capacity_type = lookup(var.capacity_type, terraform.workspace)
    
    security_group_rules = { # To comunicate between nodes (without it metrics servers do not works)
        egress_all = {
          description      = "Egress All"
          from_port        = 0
          to_port          = 0
          protocol         = "-1"
          cidr_blocks      = ["0.0.0.0/0"]
          type             = "egress"
        }
        ingress_all = {
          description      = "Ingress All"
          from_port        = 0
          to_port          = 0
          protocol         = "-1"
          cidr_blocks      = ["0.0.0.0/0"] 
          type             = "ingress"
        }
      }    
  }


  eks_managed_node_groups = {
    node = {
      //version = "1.20"       # Enable if you only need upgrade control plane
      create_launch_template = var.create_launch_template
      min_size               = var.min_size
      desired_size           = var.desired_size
      max_size               = var.max_size
      disk_size              = var.disk_size
      disk_type              = var.disk_type
      disk_iops              = var.disk_iops
      disk_throughput        = var.disk_throughput
      instance_types         = var.instance_types
      update_config = {
        max_unavailable_percentage = var.max_unavailable_percentage
      }

      k8s_labels = merge(
        local.common_tags,
        {
          "cluster-name" = local.eks_cluster_name
        }
      )
    }
  }

  tags = merge(
    local.common_tags,
    {
      "beta.kubernetes.io/os"                               = "linux"
      "kubernetes.io/os"                                    = "linux"
      "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"                   = "true"
    }
  )

}


output "eks_cluster_name" {
  value = module.eks_cluster.cluster_id
}
