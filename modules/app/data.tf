data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "RHEL-9-DevOps-Practice"
  owners      = ["973714476881"]
}

data "vault_generic_secret" "ssh" {
  path = "common1/common"
 // path = "common/ssh"
}
# as we created our own security group ..no need of using this
#data "aws_security_group" "selected" {
#    name = "allow-all"
#}