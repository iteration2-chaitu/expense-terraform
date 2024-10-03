output "message"
{
  value = "Welcome to expense project, Env-${var.env}"
}

variable "env"{
  default = "10"
}