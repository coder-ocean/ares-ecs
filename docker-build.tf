resource "null_resource" "build_push_backend" {

  provisioner "local-exec" {

    command = <<EOT

aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com

docker build -t flask-backend ../backend
docker tag flask-backend:latest ${aws_ecr_repository.backend.repository_url}:latest
docker push ${aws_ecr_repository.backend.repository_url}:latest

EOT
  }

  depends_on = [aws_ecr_repository.backend]

}

resource "null_resource" "build_push_frontend" {

  provisioner "local-exec" {

    command = <<EOT

docker build -t express-frontend ../frontend
docker tag express-frontend:latest ${aws_ecr_repository.frontend.repository_url}:latest
docker push ${aws_ecr_repository.frontend.repository_url}:latest

EOT
  }

  depends_on = [aws_ecr_repository.frontend]

}