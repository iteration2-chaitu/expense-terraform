resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id           #aws_vpc.main.id

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
   protocol         = "-1"  # all trafic
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}


resource "aws_instance" "instance"{
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id ]    # [data.aws_security_group.selected.id]
  subnet_id = var.subnets[0]    # this should be added after creating the vpc

  tags = {
    Name = var.component
    monitor="yes"
    env = var.env
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }

}

resource "aws_route53_record" "instance"{
#  ami = ""
#  instance_type = ""
  name = "${var.component}-${var.env}"
  type = "A"
  zone_id = var.zone_id
  records = [aws_instance.instance.private_ip]
  ttl = 30
}

resource "null_resource" "ansible" {

  connection {
    type     = "ssh"
    //user     = var.ssh_user   #"ec2-user"
    user     = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
    //password = var.ssh_password   #"DevOps321"
    password = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
    #      host     = aws_instance.instance.public_ip
    host     = aws_instance.instance.private_ip   #this is once we create nat gateways
  }
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "remote-exec" {

    inline = [
      #      "sudo dnf install nginx -y",
      #      "sudo systemctl start nginx"
      "rm -rf ~/secrets.json ~/app.json",
      "sudo pip3.11 install ansible hvac",
      "ansible-pull -i localhost, -U https://github.com/iteration2-chaitu/expense-ansible.git get-secrets.yml -e env=${var.env}  -e role_name=${var.component} -e vault_token=${var.vault_token}",
      "ansible-pull -i localhost, -U https://github.com/iteration2-chaitu/expense-ansible.git expense-pipeline.yml -e env=${var.env}  -e role_name=${var.component} -e @~/secrets.json -e @~/app.json",
      "rm -rf ~/secrets.json ~/app.json"

    ]
  }
  provisioner "remote-exec" {
    inline = [
      "rm -rf ~/secrets.json ~/app.json"

    ]
  }
}

resource "aws_lb" "main" {
  count              = var.lb_needed ? 1 : 0
  name               = "${var.env}-${var.component}-alb"
  internal           = var.lb_type == "public" ? false : true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.lb_subnets

  tags = {
    Environment = "${var.env}-${var.component}-alb"
  }
}

resource "aws_lb_target_group" "main" {
  count              = var.lb_needed ? 1 : 0
  name               = "${var.env}-${var.component}-tg"
  port               = var.app_port
  protocol           = "HTTP"
  vpc_id             = var.vpc_id
  deregistration_delay = 15

  health_check {
    healthy_threshold    = 2
    interval             = 5
    path                 = "/health"
    port                 = var.vpc_id
    unhealthy_threshold  = 2
    timeout              = 2
  }
}
resource "aws_lb_target_group_attachment" "main" {
  count              = var.lb_needed ? 1 : 0
  target_group_arn = aws_lb_target_group.main[0].arn
  target_id        = aws_instance.instance.id
  port             = var.app_port
}

resource "aws_lb_listener" "front_end" {
  count              = var.lb_needed ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}


#  provisioner "remote-exec" {   ...this is  a single provisoner
#
#    connection {
#      type     = "ssh"
#      //user     = var.ssh_user   #"ec2-user"
#      user     = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
#      //password = var.ssh_password   #"DevOps321"
#      password = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
##      host     = aws_instance.instance.public_ip
#      host     = aws_instance.instance.private_ip   #this is once we create nat gateways
#    }
#
#    inline = [
##      "sudo dnf install nginx -y",
##      "sudo systemctl start nginx"
#      "sudo pip3.11 install ansible hvac",
#      "ansible-pull -i localhost, -U https://github.com/iteration2-chaitu/expense-ansible.git get-secrets.yml -e env=${var.env}  -e role_name=${var.component} -e vault_token=${var.vault_token}",
#      "ansible-pull -i localhost, -U https://github.com/iteration2-chaitu/expense-ansible.git expense-pipeline.yml -e env=${var.env}  -e role_name=${var.component} -e @~/secrets.json -e @~/app.json",
#      "rm -rf ~/secrets.json ~/app.json"
#
#    ]
#  }