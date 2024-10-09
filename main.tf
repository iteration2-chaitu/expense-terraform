 module "frontend" {
   //depends_on              = [module.backend]
   source                  = "./modules/app"
 component                 =  "frontend"
   env                     =  var.env
   instance_type           = var.instance_type
   ssh_user                = var.ssh_user
   ssh_password            = var.ssh_password
    zone_id                 = var.zone_id
 }
 module "backend" {
   depends_on         =[module.mysql]
   source                  = "./modules/app"
   component                 =  "backend"
   env                     =  var.env
   instance_type           = var.instance_type
   ssh_user                = var.ssh_user
   ssh_password            = var.ssh_password
   zone_id                 = var.zone_id
 }
 module "mysql" {
   source                  = "./modules/app"
   component                 =  "mysql"
   env                     =  var.env
   instance_type           = var.instance_type
   ssh_user                = var.ssh_user
   ssh_password            = var.ssh_password
   zone_id                 = var.zone_id
 }


# module "backend" {
#   source                  = "./modules/app"
   #   app_port                = 80
   #   bastion_nodes           = var.bastion_nodes
   #   component               = "frontend"
   #   env                     = var.env
   #   instance_type           = var.instance_type
   #   max_capacity            = var.max_capacity
   #   min_capacity            = var.min_capacity
   #   prometheus_nodes        = var.prometheus_nodes
   #   server_app_port_sg_cidr = var.public_subnets
   #   subnets                 = module.vpc.frontend_subnets
   #   vpc_id                  = module.vpc.vpc_id
   #   vault_token             = var.vault_token
   #   certificate_arn         = var.certificate_arn
   #   lb_app_port_sg_cidr     = ["0.0.0.0/0"]
   #   lb_ports                = { http : 80, https : 443 }
   #   lb_subnets              = module.vpc.public_subnets
   #   lb_type                 = "public"
   #   zone_id                 = var.zone_id
   #   kms_key_id              = var.kms_key_id

# }

# module "mysql" {
#   source                  = "./modules/app"
   #   app_port                = 80
   #   bastion_nodes           = var.bastion_nodes
   #   component               = "frontend"
   #   env                     = var.env
   #   instance_type           = var.instance_type
   #   max_capacity            = var.max_capacity
   #   min_capacity            = var.min_capacity
   #   prometheus_nodes        = var.prometheus_nodes
   #   server_app_port_sg_cidr = var.public_subnets
   #   subnets                 = module.vpc.frontend_subnets
   #   vpc_id                  = module.vpc.vpc_id
   #   vault_token             = var.vault_token
   #   certificate_arn         = var.certificate_arn
   #   lb_app_port_sg_cidr     = ["0.0.0.0/0"]
   #   lb_ports                = { http : 80, https : 443 }
   #   lb_subnets              = module.vpc.public_subnets
   #   lb_type                 = "public"
   #   zone_id                 = var.zone_id
   #   kms_key_id              = var.kms_key_id

# }
