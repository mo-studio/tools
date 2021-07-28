resource "aws_lb" "alb" {
  name               = "${var.service}-${var.env}-${var.app}-alb"
  subnets            = var.dmz_subnets
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.service}-${var.env}-${var.app}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = var.health_check
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type          = "redirect"
    redirect {
      port          = "443"
      protocol      = "HTTPS"
      status_code   = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certifcate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
