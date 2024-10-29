#for storing the variables
env = "dev"
instance_type = "t3.small"
component = "frontend"
#ssh_user = "ec2-user"
#ssh_password = "DevOps321"
zone_id = "Z1029901SH2BJPKJS7Q3"
vpc_cidr_block =  "10.10.0.0/24"  # have to remove it as we r creating more subnets
#subnet_cidr_block =  "10.10.0.0/24"
default_vpc_id =  "vpc-0a163cb4c65657a98"
default_vpc_cidr =  "172.31.0.0/16"
default_route_table_id =  "rtb-0287c0dba3f29d4a5"

frontend_subnets = [ "10.10.0.0/27","10.10.0.32/27" ]
backend_subnets  = [ "10.10.0.64/27" , "10.10.0.96/27"]
db_subnets = ["10.10.0.128/27" , "10.10.0.160/27"]
public_subnets = ["10.10.0.192/27","10.10.0.224/27"]
availability_zones = ["us-east-1a","us-east-1b"]