variable "env" {}
variable "instance_type" {}
variable "component"{}
#variable "ssh_user"{}
#variable "ssh_password"{}
variable "zone_id" {}
variable "vault_token"{}
variable vpc_cidr_block {}
#variable subnet_cidr_block{}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}
variable "default_route_table_id" {}

variable "frontend_subnets"{}
variable "backend_subnets" {}
variable "db_subnets" {}
variable "availability_zones" {}
variable "public_subnets" {}
#variable "subnets" {}
#variable "vpc_id" {}