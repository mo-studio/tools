include {
  path = find_in_parent_folders()
}

terraform{
    source = "../../../modules/rds"
}

inputs = {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.m5.large"
  name                 = "amp"
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true
  vpc_id               = "vpc-0d2243c773b64ca5b"
  db_subnets            = ["subnet-08608df1f594e4e42","subnet-097e05ff96d22fdda"]
}