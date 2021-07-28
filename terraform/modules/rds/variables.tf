variable  "allocated_storage"{
    type = string
}

variable "vpc_id" {
    type = string
}
variable  "engine"{
    type = string
}
variable  "engine_version"{
    type = string
}
variable  "instance_class"{
    type = string
}
variable  "name"{
    type = string
}
variable  "username"{
    type = string
}
variable  "password"{
    type = string
}
variable  "parameter_group_name"{
    type = string
}
variable  "skip_final_snapshot"{
    type = bool
}

variable "db_subnets" {
    type = "list"
}
