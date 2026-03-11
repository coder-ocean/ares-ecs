resource "aws_ecs_cluster" "main" {

  name = "flask-express-cluster"

}

####################################
# BACKEND TASK DEFINITION
####################################

resource "aws_ecs_task_definition" "backend" {

  family                   = "backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = "${aws_ecr_repository.backend.repository_url}:latest"

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])

}

####################################
# FRONTEND TASK DEFINITION
####################################

resource "aws_ecs_task_definition" "frontend" {

  family                   = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = "${aws_ecr_repository.frontend.repository_url}:latest"

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

}

####################################
# BACKEND ECS SERVICE
####################################

resource "aws_ecs_service" "backend" {

  name            = "backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn

  launch_type   = "FARGATE"
  desired_count = 1

  network_configuration {

    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]

    security_groups = [aws_security_group.ecs_sg.id]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 5000

  }

  depends_on = [
    aws_lb_listener.http
  ]

}

####################################
# FRONTEND ECS SERVICE
####################################

resource "aws_ecs_service" "frontend" {

  name            = "frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn

  launch_type   = "FARGATE"
  desired_count = 1

  network_configuration {

    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]

    security_groups = [aws_security_group.ecs_sg.id]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 3000

  }

  depends_on = [
    aws_lb_listener.http
  ]

}