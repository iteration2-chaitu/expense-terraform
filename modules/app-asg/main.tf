resource "aws_launch_template" "main" {
  name         = "${var.component}-${var.env}"
  image_id    = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh",{
    component = var.component
    env       = var.env
    vault_token = var.vault_token
  }))

}

resource "aws_autoscaling_group" "main" {
  name                = "${var.component}-${var.env}"
  desired_capacity    = var.min_capacity
  max_size            = var.max_capacity
  min_size            = var.min_capacity
  vpc_zone_identifier = var.subnets
  target_group_arns   = [aws_lb_target_group.main.arn]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.component}-${var.env}"
  }
}

resource "aws_lb_target_group" "main" {
  port         = var.app_port
  protocol     = "HTTP"
  vpc_id     = var.vpc_id
  deregistration_delay = 15

  health_check {
    healthy_threshold    = 2
    interval             = 5
    path                 = "/health"
    port                 = var.app_port
    unhealthy_threshold  = 2
    timeout              = 2
  }

}
resource "aws_autoscaling_policy" "main" {
  name                   = "target-cpu"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id           #aws_vpc.main.id

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
  ingress {
    from_port        = var.app_port   #0
    to_port          = var.app_port
    protocol         =  "TCP"          #  "-1" for public ones
    cidr_blocks      =  var.server_app_port_sg_cidr       #["0.0.0.0/0"]
    #    ipv6_cidr_blocks = ["::/0"]

  }
  ingress {
    from_port        = 22   #workstation
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = var.bastion_nodes
    #    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 9100   #prometheus
    to_port          = 9100
    protocol         = "TCP"
    cidr_blocks      = var.prometheus_nodes
    #    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # all traffic
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}

