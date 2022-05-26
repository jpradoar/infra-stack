resource "aws_ecr_repository" "ecr" {
  count                = var.ifecr == true ? 1 : 0
  name                 = var.ecr_name
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
}