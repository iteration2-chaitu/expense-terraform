resource "aws_instance" "instance"{
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = var.component
    monitor="yes"
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

resource "null_resource" "ansible"{

  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = var.ssh_user   #"ec2-user"
      password = var.ssh_password   #"DevOps321"
      host     = aws_instance.instance.public_ip
    }

    inline = [
#      "sudo dnf install nginx -y",
#      "sudo systemctl start nginx"
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost, -U https://github.com/iteration2-chaitu/expense-ansible.git expense-pipeline.yml -e env=${var.env}  -e role_name=${var.component}"

    ]
  }



}