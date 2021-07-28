

terraform {
  backend "s3" {}
}
 
resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name              = "/ecs/${var.service}/"
  retention_in_days = 14
}


resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.service}-${var.app}-${var.env}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.service}-${var.app}-${var.env}",
      "image":  "${var.ecs_task_definition_image}",
      "essential": true,
      "memory": ${var.ecs_memory},
      "cpu": ${var.ecs_cpu},
      "portMappings": [
        {
          "containerPort": ${var.app_port},
          "protocol" : "tcp"
        }
      ],
      "environment": ${var.env_vars},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-stream-prefix": "task-${var.service}-web",
          "awslogs-region": "us-gov-west-1",
          "awslogs-group": "/ecs/${var.service}/"
        }
      }
    }
  ]
  DEFINITION
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = data.aws_iam_role.task_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name                    = "${var.service}-${var.app}-${var.env}"
  cluster                 = data.aws_ecs_cluster.ecs_cluster.id
  task_definition         = aws_ecs_task_definition.task_definition.arn
  enable_ecs_managed_tags = true
  launch_type   = "EC2"
  desired_count = var.desired_count
  network_configuration {
    subnets = var.app_subnets
    security_groups = [ data.aws_security_group.ecs_task_sg.id, aws_security_group.lb_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_port   = var.app_port
    container_name   = "${var.service}-${var.app}-${var.env}" // matches task definition
  }

  depends_on = [
    aws_lb_listener.alb_listener
  ]
}

