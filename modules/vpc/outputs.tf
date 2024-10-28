output "vpc_id"{
 value = aws_vpc.main.id
}

output "frontend_subnets" {
  value = aws_subnet.frontend.*.id   # this output is a list ..to capture it we need this
}

output "backend_subnets" {
  value = aws_subnet.backend.*.id   # this output is a list ..to capture it we need this
}

output "db_subnets" {
  value = aws_subnet.db.*.id   # this output is a list ..to capture it we need this
}