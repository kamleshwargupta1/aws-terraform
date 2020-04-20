variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "database_subnets" {
  description = "A list of database_subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}


variable "web_server" {
  description = "A list of web_server subnets"
  type        = list(string)
  default     = []
}




variable "rds_mysql" {
  description = "A list of rds_mysql-database subnets"
  type        = list(string)
  default     = []
}

variable "efs" {
  description = "A list of efs subnets"
  type        = list(string)
  default     = []
}

variable "alb" {
  description = "A list of alb subnets"
  type        = list(string)
  default     = []
}

variable "elb" {
  description = "A list of elb subnets"
  type        = list(string)
  default     = []
}

variable "ssh" {
  description = "A list of ssh subnets"
  type        = list(string)
  default     = []
}

variable "elastic_search" {
  description = "A list of elastic_search subnets"
  type        = list(string)
  default     = []
}

variable "nat" {
  description = "A list of nat subnets"
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}


variable "private_subnets" {
  description = "A list of private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets"
  type        = list(string)
  default     = []
}

variable "web_server_subnets" {
  description = "A list of web server subnets"
  type        = list(string)
  default     = []
}

variable "rds_mysql_subnets" {
  description = "A list of rds mysql subnets"
  type        = list(string)
  default     = []
}
variable "efs_subnets" {
  description = "A list of efs subnets"
  type        = list(string)
  default     = []
}

variable "alb_subnets" {
  description = "A list of alb subnets"
  type        = list(string)
  default     = []
}
variable "elb_subnets" {
  description = "A list of elb subnets"
  type        = list(string)
  default     = []
}

variable "ssh_subnets" {
  description = "A list of ssh subnets"
  type        = list(string)
  default     = []
}

variable "nat_subnets" {
  description = "A list of nat subnets"
  type        = list(string)
  default     = []
}

variable "elastic_search_subnets" {
  description = "A list of elastic_search subnets"
  type        = list(string)
  default     = []
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  type        = bool
  default     = false
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = null
}
variable "enable_classiclink_dns_support" {
  description = "Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = null
}
variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}
variable "vpc_endpoint_tags" {
  description = "Additional tags for the VPC Endpoints"
  type        = map(string)
  default     = {}
}
variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set (requires enable_dhcp_options set to true)"
  type        = map(string)
  default     = {}
}
variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = false
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}
variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = []
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
}
variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  type        = string
  default     = "db"
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}
variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}
variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created"
  type        = bool
  default     = true
}
variable "database_subnet_group_tags" {
  description = "Additional tags for the database subnet group"
  type        = map(string)
  default     = {}
}





variable "public_subnets_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "private_subnets_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}


variable "web_server_subnets_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "Web-Server"
}

variable "rds_mysql_subnets_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "RDS-MySQL"
}

variable "efs_subnets_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "EFS"
}

variable "alb_subnets_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "ALB"
}

variable "elb_subnets_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "ELB"
}

variable "ssh_subnets_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "SSH-Gateway"
}

variable "nat_subnets_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "NAT-Gateway"
}

variable "elastic_search_subnets_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "ElasticSearch"
}



variable "public_subnets_prefix" {
  description = "prefix to append to public subnets name"
  type        = string
  default     = "Public-Subnet"
}

variable "private_subnets_prefix" {
  description = "prefix to append to private subnets name"
  type        = string
  default     = "Public-Subnet"
}


variable "web_server_subnets_prefix" {
  description = "prefix to append to public subnets name"
  type        = string
  default     = "Private-Subnet"
}

variable "rds_mysql_subnets_prefix" {
  description = "prefix to append to private subnets name"
  type        = string
  default     = "Private-Subnet"
}

variable "efs_subnets_prefix" {
  description = "prefix to append to public subnets name"
  type        = string
  default     = "Private-Subnet"
}

variable "alb_subnets_prefix" {
  description = "prefix to append to private subnets name"
  type        = string
  default     = "Public-Subnet"
}

variable "elb_subnets_prefix" {
  description = "prefix to append to public subnets name"
  type        = string
  default     = "Public-Subnet"
}

variable "ssh_subnets_prefix" {
  description = "prefix to append to private subnets name"
  type        = string
  default     = "Public-Subnet"
}

variable "nat_subnets_prefix" {
  description = "prefix to append to public subnets name"
  type        = string
  default     = "Public-Subnet"
}

variable "elastic_search_subnets_prefix" {
  description = "prefix to append to private subnets name"
  type        = string
  default     = "Private-Subnet"
}


variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}
variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

