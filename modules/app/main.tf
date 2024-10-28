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

#resource "null_resource" "ansible"{
#
#  triggers = {
#    always_run = "${timestamp()}"
#  }
#  provisioner "remote-exec" {
#
#    connection {
#      type     = "ssh"
#      //user     = var.ssh_user   #"ec2-user"
#      user     = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
#      //password = var.ssh_password   #"DevOps321"
#      password = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
#      host     = aws_instance.instance.public_ip
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
#
#}