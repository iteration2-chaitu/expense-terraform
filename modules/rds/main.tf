resource "aws_db_instance" "main" {
  identifier           = "${var.component}-${var.env}-pg"

  db_name              = "mydb"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = jsondecode(data.vault_generic_secret.rds.data_json).rds_username
  password             = jsondecode(data.vault_generic_secret.rds.data_json).rds_password
  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = var.skip_final_snapshot
  multi_az             = false
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_db_parameter_group" "main" {
  name   = "${var.component}-${var.env}-pg"
  family = var.family
}

resource "aws_db_subnet_group" "default" {
  name                        = "${var.component}-${var.env}-subnet-group"
  subnet_ids                  = var.subnet_ids
  tags = {
    Name = "${var.component}-${var.env}-subnet-group"
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
    from_port        =  3306   #0
    to_port          =  3306
    protocol         =  "TCP"          #  "-1" for public ones
    cidr_blocks      =  var.server_app_port_sg_cidr       #["0.0.0.0/0"]
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






