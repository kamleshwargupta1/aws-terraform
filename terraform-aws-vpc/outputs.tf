output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_vpc.this.*.default_security_group_id, [""])[0]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}



# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
output "web_server_subnets" {
  description = "List of IDs of private subnets"
  value       = var.web_server_subnets
}

output "WebServer_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.web_server.*.id
}

output "alb_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.alb_subnets.*.id
}
output "ssh_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.ssh_subnets.*.id
}

output "rds_mysql_subnets" {
  description = "List of IDs of RDS subnets"
  value       = aws_subnet.database_server.*.id
}
