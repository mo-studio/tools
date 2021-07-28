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

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.ecs_cluster_name
}