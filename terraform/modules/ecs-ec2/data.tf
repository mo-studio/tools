data "aws_iam_role" "service_role" {
  name = "ecsServiceRole"
}

data "aws_iam_role" "task_role" {
  name = "ecsTaskRole"
}

data "aws_security_group" "ecs_task_sg" {
    filter {
      name = "tag:Name"
      values = ["ecs_task_security_group"]
    }
}

data "aws_security_group" "api_lb_sg" {
    filter {
      name = "tag:Name"
      values = ["api_lb_sg"]
    }
}

data "aws_security_group" "keycloak_lb_sg" {
    filter {
      name = "tag:Name"
      values = ["keycloak_lb_sg"]
    }
}

data "aws_security_group" "dashboard_lb_sg" {
    filter {
      name = "tag:Name"
      values = ["dashboard_lb_sg"]
    }
}

data "aws_ami" "ecs" {
  most_recent = true # get the latest version

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"] # ECS optimized image, if you don't put -hvm- it pulls -gpu- type
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"] # Only official images
}

data "template_file" "user_data" {
  template = <<EOT
#!/bin/bash
echo "ECS_CLUSTER=${var.aws_ecs_cluster_name}" >> /etc/ecs/ecs.config
systemctl restart ecs
EOT
}
