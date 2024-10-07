output "message" {
  value = [
    "Welcome to expense project, Env- ${var.env}",
     "${var.env}"
#    var.env1
  ]
}

#variable "env"{
#  default = 10
#}

#variable  "env"{
#  default = 20
#}