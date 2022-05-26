resource "aws_ebs_encryption_by_default" "volume_encryption" {
  count   = var.ifvolume_encryption == true ? 1 : 0
  enabled = true
}
