variable "env" {}
variable "instance_type" {}
variable "component"{}
#variable "ssh_user"{}
#variable "ssh_password"{}
variable "zone_id" {}
variable "vault_token" {}
variable "subnets" {}
variable "vpc_id" {}
variable "lb_type" {
  default = null
}
variable "lb_needed" {
  default = false
}

variable "lb_subnets" {
  default = null
}