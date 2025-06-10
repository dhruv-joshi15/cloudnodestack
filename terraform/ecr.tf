resource "aws_ecr_repository" "app" {
  name                 = "safle-node-app"
  image_tag_mutability = "MUTABLE"
}
