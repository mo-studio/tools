terraform {
  backend "s3" {}
}
 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.service}-ecs-cluster-${var.env}"
}
