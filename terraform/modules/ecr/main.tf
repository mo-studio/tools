
  
resource "aws_ecr_repository" "amp-repos" {
  for_each = toset(var.ecr_repos)
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
