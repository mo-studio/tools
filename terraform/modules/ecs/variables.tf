variable "service" {
    type = string
}

variable "desired_count" {
    type = number
}

variable "app" {
    type = string
}

variable "env_vars" {
    type = string
}

variable "app_port" {
    type = string
}

variable "env" {
    type = string
}

variable "health_check" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "ecs_cpu" {
    type = string
}

variable "ecs_memory" {
    type = string
}
variable "app_subnets" {
    type = list
}

variable "dmz_subnets" {
    type = list
}

variable "vpc_id" {
    type = string
}

variable "certifcate_arn" {
    type = string
}

variable "ecs_task_definition_image" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}