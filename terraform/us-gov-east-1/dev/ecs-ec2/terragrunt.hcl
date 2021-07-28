include {
  path = find_in_parent_folders()
}

terraform{
    source = "../../../modules/ecs-ec2"
}

inputs = {
    service                      = "amp"
    env                           = "dev"
    aws_ecs_cluster_name          = "amp-ecs-cluster-dev"
    dmz_subnets                   = ["subnet-01f33c176d85f7cad","subnet-0230becab37f0c2af","subnet-0389249f907e331fd"]
    desired_count                 =  1
    instance_type                 = "m5.4xlarge"
    app_subnets                   = ["subnet-046f7c8e312539285","subnet-0c0e826507559e432","subnet-030e79bee9a71c843"]
}