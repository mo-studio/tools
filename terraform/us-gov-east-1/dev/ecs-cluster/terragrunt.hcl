include {
  path = find_in_parent_folders()
}

terraform{
    source = "../../../modules/ecs-cluster"
}

inputs = {
    service                      = "amp"
    env                           = "dev"
}