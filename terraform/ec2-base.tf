resource "aws_iam_instance_profile" "this" {
  name = local.resources_name
  role = "session-manager-role"
}


resource "aws_key_pair" "keypair" {
  key_name   = "kp-${var.ec2_name}"
  public_key = var.ec2-ssh-public-key
}



data "aws_ami" "aws_ami_type" {
  most_recent = var.ec2_ami_most_recent
  filter {
    name   = "name"
    values = var.ec2_ami_filter_image
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.ec2_ami_owners
}



module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "sg_${var.ec2_name}"
  description = "security group for EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.sg_ingress_cidr_blocks
  ingress_rules       = var.sg_rules

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags

}


module "ec2_complete" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  name                   = "ec2-${var.ec2_name}"
  ami                    = data.aws_ami.aws_ami_type.id
  instance_type          = lookup(var.ec2_flavor, terraform.workspace)
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.public_subnets, 0) # if you need this instance in a private, replace module.vpc.private_subnets
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  #placement_group             = aws_placement_group.web.id
  associate_public_ip_address = var.associate_public_ip_address
  enable_volume_tags          = true
  key_name                    = "kp-${var.ec2_name}"
  #user_data                  = data.template_cloudinit_config.config.rendered
  user_data = file("./provisioning/user_data.sh")

  root_block_device = [{
    encrypted             = true
    volume_type           = var.ebs_root_volume_type
    volume_size           = var.ebs_root_volume_size
    throughput            = var.ebs_root_throughput
    delete_on_termination = var.ebs_root_delete_on_termination
    }
  ]
  ebs_block_device = [{
    encrypted             = true
    volume_type           = var.ebs_data_volume_type
    volume_size           = var.ebs_data_volume_size
    throughput            = var.ebs_data_throughput
    device_name           = var.ebs_data_device_name
    delete_on_termination = var.ebs_data_delete_on_termination
    #kms_key_id  = aws_kms_key.this.arn
    }
  ]

}



#--------------------- OUTPUTS ---------------------------------

output "ec2_priv_ip" {
  value = module.ec2_complete.private_dns
}

output "ec2_pub_ip" {
  value = module.ec2_complete.public_dns
}
