include {
  path = find_in_parent_folders()
}

terraform{
    source = "../../../modules/ecs"
}

inputs = {
    service                      = "amp"
    env                           = "dev"
    app                           = "api"
    app_port                      = "3000"
    health_check                  = "/api/v1/healthcheck"
    ecs_cluster_name              = "amp-ecs-cluster-dev"
    dmz_subnets                   = ["subnet-01f33c176d85f7cad","subnet-0230becab37f0c2af","subnet-0389249f907e331fd"]
    desired_count                 =  1
    instance_type                 = "m5.large"
    lb_internal                   = true
    load_balancer_type            = "application"
    enable_deletion_protection    = false
    ecs_task_definition_image     = "368457484834.dkr.ecr.us-gov-west-1.amazonaws.com/amp-api:latest"
    ecs_cpu                       = 256
    ecs_memory                    = 512
    ecs_task_definition_essential = true
    ecs_host_port                 = 3000
    # cidr_block                  = ""
    listener_port                 = 80
    # ssl_policy                  = 
    certifcate_arn                = "arn:aws-us-gov:acm:us-gov-west-1:368457484834:certificate/b6f2c872-7486-4c05-b926-673315cd0eec"
    ecs_service_name              = "amp-api-dev"
    app_subnets                   = ["subnet-046f7c8e312539285","subnet-0c0e826507559e432","subnet-030e79bee9a71c843"]
    ecs_region                    = "us-gov-west-1"
    vpc_id                        = "vpc-0d2243c773b64ca5b"
    env_vars                      = <<EOT
    [
         { 
           "name" : "DB_USERNAME",
           "value" : "amp_app_user"
         },
         { 
           "name" : "DB_PASSWORD",
           "valueFrom" : "db_password"
         },
         { 
           "name" : "DB_HOST",
           "value" : "20210511202316947500000001.cjlky3c7uh80.us-gov-west-1.rds.amazonaws.com"
         },
         { 
           "name" : "DB_NAME",
           "value" : "amp"
         },
         {
           "name" : "DB_PORT",
           "value" : "5432"
         }
       ]
       EOT
}