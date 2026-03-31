resource "aws_ecr_repository" "app" {
  name                 = "${var.name_prefix}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-app-repo" })
}

resource "aws_ecr_repository" "sidecar" {
  name                 = "${var.name_prefix}-sidecar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-sidecar-repo" })
}

resource "aws_ecr_lifecycle_policy" "cleanup" {
  # Apply to both repositories
  for_each   = toset([aws_ecr_repository.app.name, aws_ecr_repository.sidecar.name])
  repository = each.value

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
