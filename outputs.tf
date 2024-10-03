output "message" {
  value = [
    "Welcome to expense project, Env- ${var.env1}",
     "${var.env1}"
#    var.env1
  ]
}

#variable "env"{
#  default = 10
#}

variable  "env1"{
  default = 20
}