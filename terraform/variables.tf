#---------------------------- AWS ACCOUNT --------------------------------

variable "aws_region" {
  type        = string
  description = "AWS Region where the resources will be deployed"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key where the resources will be deployed"
  default     = ""
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Access Key where the resources will be deployed"
  default     = ""
}

variable "aws_profile" {
  type        = string
  description = "AWS profile name as set in the shared credentials file"
}

#------------------------- METADATA --------------------------------
variable "product" {
  type        = string
  description = "Product"
}

variable "client" {
  type        = string
  description = "Client"
}

variable "environment" {
  type        = string
  description = "Product Enviromennt"
}


#------------------------- GENERAL --------------------------------

variable "git_tag" { default = "1.0.0" } # I use it to know the origin of infrastructure version in my repo

# ENABLE OR NOT ENABLED RESOURCES
variable "ifvolume_encryption" { default = false } # If true, enable all volume encryption on "aditional_options.tf#L2"

variable "ifecr" { default = false }

#------------------------- VPC --------------------------------


variable "cidr" { default = "10.10.0.0/20" }
variable "azs" { default = ["us-east-1a", "us-east-1b", "us-east-1c"] }
variable "private_subnets" { default = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"] }
variable "public_subnets" { default = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"] }
variable "enable_nat_gateway" { default = true }
variable "single_nat_gateway" { default = true }
variable "one_nat_gateway_per_az" { default = true }
variable "enable_dns_hostnames" { default = true } # Needed for public access to RDS instances
variable "enable_dns_support" { default = true }   # Needed for public access to RDS instances
variable "enable_flow_log" { default = false }
variable "create_flow_log_cloudwatch_log_group" { default = false }
variable "create_flow_log_cloudwatch_iam_role" { default = false }
variable "flow_log_max_aggregation_interval" { default = "60" }

#------------------------- EKS --------------------------------

variable "cluster_version" { default = "1.20" } # "Unsupported Kubernetes minor version update from 1.20 to 1.22"
variable "ami_type" { default = "AL2_x86_64" }
variable "instance_types" { default = ["m5.xlarge"] }
variable "create_launch_template" { default = true }
variable "min_size" { default = "1" }
variable "desired_size" { default = "2" }
variable "max_size" { default = "3" }
variable "disk_size" { default = "160" }
variable "disk_type" { default = "gp3" }
variable "disk_iops" { default = "3000" }
variable "disk_throughput" { default = "125" }
variable "max_unavailable_percentage" { default = "20" }
#
# variable "force_update_version" { default = true } # Not tested yet

variable "capacity_type" { # Used in eks.tf#L36
  type = map(any)
  default = {
    default = "ON_DEMAND" # use: terraform workspace default
    dev     = "SPOT"      # use: terraform workspace dev
    prod    = "ON_DEMAND" # use: terraform workspace prod
  }
}

#------------------------- RDS --------------------------------

variable "engine" { default = "mysql" }
variable "instance_class" { default = "db.t2.large" }
variable "engine_version" { default = "5.7.33" }
variable "allocated_storage" { default = "100" }
variable "storage_encrypted" { default = false }
variable "db_name" { default = "superduperdb" }
variable "port" { default = "3306" }
variable "username" { default = "admin" }
variable "password" { default = "SuperDuperPassword" }
variable "create_random_password" { default = false }
variable "create_db_subnet_group" { default = true }
variable "maintenance_window" { default = "Mon:00:00-Mon:03:00" }
variable "backup_window" { default = "03:00-06:00" }
variable "multi_az" { default = true }
variable "family" { default = "mysql5.7" }
variable "major_engine_version" { default = "5.7" }
variable "deletion_protection" { default = false }
variable "backup_retention_period" { default = "7" }

#------------------------- ECR --------------------------------
variable "ecr_name" { default = "demoregistry" }
variable "ecr_image_tag_mutability" { default = "MUTABLE" }
variable "ecr_scan_on_push" { default = "true" }


#------------------------- EC2 --------------------------------

variable "ec2_name" { default = "instance-demo" }
variable "associate_public_ip_address" { default = true }

variable "ebs_root_volume_type" { default = "gp3" }
variable "ebs_root_volume_size" { default = "60" }
variable "ebs_root_throughput" { default = "200" }
variable "ebs_root_delete_on_termination" { default = true }

# For ec2 best practices is prefere separate data in a second ebs and avoid use root file system
variable "ebs_data_volume_type" { default = "gp3" }
variable "ebs_data_volume_size" { default = "20" }
variable "ebs_data_throughput" { default = "200" }
variable "ebs_data_device_name" { default = "/dev/sdf" }
variable "ebs_data_delete_on_termination" { default = false }

variable "sg_ingress_cidr_blocks" { default = ["0.0.0.0/0", "8.8.8.8/32"] }
variable "sg_rules" { default = ["http-80-tcp", "https-443-tcp", "ssh-tcp"] }

variable "ec2_ami_most_recent" { default = true }
variable "ec2_ami_filter_image" { default = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] }
variable "ec2_ami_owners" { default = ["099720109477"] } # Canonical ID 099720109477

variable "ec2_flavor" { # Used in ec2-base.tf#L44
  type = map(any)
  default = {
    default = "t2.micro"
    dev     = "t2.large"  # use: terraform workspace dev
    prod    = "m5.xlarge" # use: terraform workspace prod
  }
}

variable "ec2-ssh-public-key" { default = "" } # Declared in terraform.tfvars


#------------ OUTPUTS ------------

output "data_aws_region" {
  value = var.aws_region
}