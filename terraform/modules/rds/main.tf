
  
resource "aws_db_instance" "amp-db" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = data.aws_ssm_parameter.db_username.value
  password             = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name = aws_db_subnet_group.rds.name
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [ aws_security_group.ecs_task.id ]
  publicly_accessible   = false
}

resource "aws_db_subnet_group" "rds" {
  name       = "database_subnet"
  subnet_ids = var.db_subnets

  tags = {
    Name = "RDS subnet"
  }
}

