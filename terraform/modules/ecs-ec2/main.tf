terraform {
  backend "s3" {}
}
resource "aws_launch_configuration" "primary" {
  name_prefix                 = "${var.service}-${var.env}-lc"
  image_id                    = data.aws_ami.ecs.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = "ecsInstanceProfile"
  security_groups             = [data.aws_security_group.api_lb_sg.id, data.aws_security_group.ecs_task_sg.id,data.aws_security_group.keycloak_lb_sg.id,data.aws_security_group.dashboard_lb_sg.id]
  ebs_optimized               = false
  associate_public_ip_address = false
  user_data                   = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.service}-${var.env}-asg"
  vpc_zone_identifier = var.app_subnets
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1 # You need one for service, then beyond that they can be used for ec2 instances for container hosting

  launch_configuration = aws_launch_configuration.primary.name

  tag {
    key                 = "Name"
    value               = "${var.service}-${var.env}"
    propagate_at_launch = true
  }

}
