# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Private Subnets IDs
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}
#Public Subnets IDs
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}
# Subnets CIDR 
output "web_server_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.web_server_subnets
}

output "WebServer_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.WebServer_subnets
}

output "alb_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.alb_subnets
}

output "ssh_subnets" {
  description = "List of IDs of ssh subnets"
  value       = module.vpc.ssh_subnets
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = module.ec2_ssh.public_ip[0]

}
############################################ ALB Outputs################################

output "this_lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.this_lb_id
}

output "this_lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.this_lb_arn
}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.this_lb_dns_name
}

output "this_lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb.this_lb_arn_suffix
}

output "this_lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.this_lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.alb.https_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = module.alb.target_group_arn_suffixes
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.alb.target_group_names
}

############################################## EC2 Instance ###############################

output "ids" {
  description = "List of IDs of instances"
  value       = module.ec2_ssh.id
}
/*

output "ids_t2" {
  description = "List of IDs of t2-type instances"
  value       = module.ec2_with_t2_unlimited.id
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = module.ec2.public_dns
}

output "vpc_security_group_ids" {
  description = "List of VPC security group ids assigned to the instances"
  value       = module.ec2.vpc_security_group_ids
}

output "root_block_device_volume_ids" {
  description = "List of volume IDs of root block devices of instances"
  value       = module.ec2.root_block_device_volume_ids
}

output "ebs_block_device_volume_ids" {
  description = "List of volume IDs of EBS block devices of instances"
  value       = module.ec2.ebs_block_device_volume_ids
}

output "tags" {
  description = "List of tags"
  value       = module.ec2.tags
}

output "placement_group" {
  description = "List of placement group"
  value       = module.ec2.placement_group
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.id[0]
}

output "t2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_with_t2_unlimited.id[0]
}

output "instance_public_dns" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = module.ec2.public_dns[0]
}

output "credit_specification" {
  description = "Credit specification of EC2 instance (empty list for not t2 instance types)"
  value       = module.ec2.credit_specification
}

output "credit_specification_t2_unlimited" {
  description = "Credit specification of t2-type EC2 instance"
  value       = module.ec2_with_t2_unlimited.credit_specification
}
*/
