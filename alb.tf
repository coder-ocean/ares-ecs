resource "aws_lb" "main" {

  name               = "flask-express-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]

}

resource "aws_lb_target_group" "frontend" {

  name        = "frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

}

resource "aws_lb_target_group" "backend" {

  name        = "backend-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn

  }

}

resource "aws_lb_listener_rule" "backend" {

  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn

  }

  condition {

    path_pattern {
      values = ["/api*"]
    }

  }

}