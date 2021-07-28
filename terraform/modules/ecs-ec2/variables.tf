variable "service" {
    type = string
}

variable "env" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "app_subnets" {
    type = list
}

variable "aws_ecs_cluster_name" {
    type = string
}