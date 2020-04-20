locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.web_server_subnets),
    length(var.rds_mysql_subnets),
    length(var.efs_subnets),
    length(var.alb_subnets),
    length(var.elb_subnets),
    length(var.ssh_subnets),
    length(var.nat_subnets),
    length(var.elastic_search_subnets)
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.this.*.id,
      [""],
    ),
    0,
  )

  vpce_tags = merge(
    var.tags,
  )
}


######
# VPC
######
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                     = var.cidr
  instance_tenancy               = var.instance_tenancy
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_dns_support             = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  #assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id = aws_vpc.this[0].id

  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

###################
# DHCP Options Set
###################
/* resource "aws_vpc_dhcp_options" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.dhcp_options_tags,
  )
} */

###############################
# DHCP Options Set Association
###############################
/* resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
} */


###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  //count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  count  = 1
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.igw_tags,
  )
}


################
# Public subnet
################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "${var.public_subnets_prefix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.private_subnets_prefix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# WebServer subnet
#################
resource "aws_subnet" "web_server" {
  count = var.create_vpc && length(var.web_server_subnets) > 0 ? length(var.web_server_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.web_server_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.web_server_subnets_prefix}-%s-${var.web_server_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# Rds_mysql Server subnet
#################
resource "aws_subnet" "database_server" {
  count = var.create_vpc && length(var.rds_mysql_subnets) > 0 ? length(var.rds_mysql_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.rds_mysql_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.rds_mysql_subnets_prefix}-%s-${var.rds_mysql_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}


#################
# EFS Server subnet
#################
resource "aws_subnet" "efs_subnets" {
  count = var.create_vpc && length(var.efs_subnets) > 0 ? length(var.efs_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.efs_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.efs_subnets_prefix}-%s-${var.efs_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# ALB Server subnet
#################
resource "aws_subnet" "alb_subnets" {
  count = var.create_vpc && length(var.alb_subnets) > 0 ? length(var.alb_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.alb_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.alb_subnets_prefix}-%s-${var.alb_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# ELB Server subnet
#################
resource "aws_subnet" "elb_subnets" {
  count = var.create_vpc && length(var.elb_subnets) > 0 ? length(var.elb_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.elb_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.elb_subnets_prefix}-%s-${var.elb_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# SSH Server subnet
#################
resource "aws_subnet" "ssh_subnets" {
  count = var.create_vpc && length(var.ssh_subnets) > 0 ? length(var.ssh_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.ssh_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.ssh_subnets_prefix}-%s-${var.ssh_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}


#################
# NAT Server subnet
#################
resource "aws_subnet" "nat_subnets" {
  count = var.create_vpc && length(var.nat_subnets) > 0 ? length(var.nat_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.nat_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.nat_subnets_prefix}-%s-${var.nat_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#################
# Elastic  Server subnet
#################
resource "aws_subnet" "elastic_search_subnets" {
  count = var.create_vpc && length(var.elastic_search_subnets) > 0 ? length(var.elastic_search_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.elastic_search_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.elastic_search_subnets_prefix}-%s-${var.elastic_search_subnets_suffix}",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}



################
# Publiс routes
################
resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.name)
    },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "alb_subnets" {
  count = var.create_vpc && length(var.alb_subnets) > 0 ? length(var.alb_subnets) : 0

  subnet_id = element(aws_subnet.alb_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "elb_subnets" {
  count = var.create_vpc && length(var.elb_subnets) > 0 ? length(var.elb_subnets) : 0

  subnet_id = element(aws_subnet.elb_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "ssh_subnets" {
  count = var.create_vpc && length(var.ssh_subnets) > 0 ? length(var.ssh_subnets) : 0

  subnet_id = element(aws_subnet.ssh_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "nat_subnets" {
  count = var.create_vpc && length(var.nat_subnets) > 0 ? length(var.nat_subnets) : 0

  subnet_id = element(aws_subnet.nat_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}
#################
# Private routes
# There are as many routing tables as the number of NAT gateways
#################
resource "aws_route_table" "private" {
  #count = var.create_vpc && local.max_subnet_length > 0 ? local.nat_gateway_count : 0
  count = 1

  vpc_id = local.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natGW.id
  }

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format(
        "%s-${var.private_subnet_suffix}-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_route_table_tags,
  )

}




resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "web_server" {
  count = var.create_vpc && length(var.web_server_subnets) > 0 ? length(var.web_server_subnets) : 0

  subnet_id = element(aws_subnet.web_server.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "rds_mysql" {
  count = var.create_vpc && length(var.rds_mysql_subnets) > 0 ? length(var.rds_mysql_subnets) : 0

  subnet_id = element(aws_subnet.database_server.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "efs_subnets" {
  count = var.create_vpc && length(var.efs_subnets) > 0 ? length(var.efs_subnets) : 0

  subnet_id = element(aws_subnet.efs_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "elastic_search_subnets" {
  count = var.create_vpc && length(var.elastic_search_subnets) > 0 ? length(var.elastic_search_subnets) : 0

  subnet_id = element(aws_subnet.elastic_search_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

##################
# Database_default subnet
##################
resource "aws_subnet" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.database_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  #assign_ipv6_address_on_creation = var.database_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.database_subnet_assign_ipv6_address_on_creation


  tags = merge(
    {
      "Name" = format(
        "%s-${var.database_subnet_suffix}-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.database_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0

  name        = lower(var.name)
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database.*.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.database_subnet_group_tags,
  )
}
###########################################################
#############    NAT Gateway Configuration ################

resource "aws_eip" "elasticIP" {
  vpc = true
}

resource "aws_nat_gateway" "natGW" {
  allocation_id = aws_eip.elasticIP.id
  subnet_id     = element(aws_subnet.nat_subnets.*.id, 0)
  //depends_on    = ["aws_internet_gateway.this[0].id"]
}

/*

# Define the Private Route table
resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natGW.id}"
  }

  tags = {
    Name = "Private Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "private1-rtAsso" {
  count          = "${var.private_subnet_count}"
  subnet_id      = element(aws_subnet.private-subnetAZ1.*.id, count.index)
  route_table_id = "${aws_route_table.private-rt.id}"
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "private2-rtAsso" {
  count          = "${var.private_subnet_count}"
  subnet_id      = element(aws_subnet.private-subnetAZ2.*.id, count.index)
  route_table_id = "${aws_route_table.private-rt.id}"
} */
