resource "aws_ecr_repository" "flask_app_repo" {
  name                 = "flask-hello-world"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "flask-hello-world"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.flask_app_repo.repository_url
}
