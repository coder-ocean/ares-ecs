resource "aws_ecr_repository" "backend" {
  name = "flask-backend"
}

resource "aws_ecr_repository" "frontend" {
  name = "express-frontend"
}