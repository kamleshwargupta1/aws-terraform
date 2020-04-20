provider "aws" {
  region = "eu-west-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

#data "aws_subnet_ids" "all" {
#  vpc_id = [module.vpc.alb_subnets.id]
#}




module "vpc" {
  source = "./terraform-aws-vpc"

  name = "MyVPC"

  cidr = "10.10.0.0/16"

  azs                    = ["eu-west-1a", "eu-west-1b"]
  private_subnets        = ["10.10.0.0/24", "10.10.1.0/24"]
  public_subnets         = ["10.10.2.0/24", "10.10.3.0/24"]
  web_server_subnets     = ["10.10.4.0/24", "10.10.5.0/24"]
  rds_mysql_subnets      = ["10.10.6.0/24", "10.10.7.0/24"]
  efs_subnets            = ["10.10.8.0/24", "10.10.9.0/24"]
  alb_subnets            = ["10.10.10.0/24", "10.10.11.0/24"]
  elb_subnets            = ["10.10.12.0/24", "10.10.13.0/24"]
  ssh_subnets            = ["10.10.14.0/24"]
  nat_subnets            = ["10.10.15.0/24"]
  elastic_search_subnets = ["10.10.20.0/24"]

  #enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets_prefix        = "Private-Subnet"
  public_subnets_prefix         = "Public-Subnet"
  web_server_subnets_prefix     = "Private-Subnet"
  rds_mysql_subnets_prefix      = "Private-Subnet"
  efs_subnets_prefix            = "Private-Subnet"
  alb_subnets_prefix            = "Public-Subnet"
  elb_subnets_prefix            = "Public-Subnet"
  ssh_subnets_prefix            = "Public-Subnet"
  nat_subnets_prefix            = "Public-Subnet"
  elastic_search_subnets_prefix = "Private-Subnet"


  private_subnets_suffix        = ""
  public_subnets_suffix         = ""
  web_server_subnets_suffix     = "Web-Server"
  rds_mysql_subnets_suffix      = "RDS-MySQL"
  efs_subnets_suffix            = "EFS"
  alb_subnets_suffix            = "ALB"
  elb_subnets_suffix            = "ELB"
  ssh_subnets_suffix            = "SSH-Gateway"
  nat_subnets_suffix            = "NAT-Gateway"
  elastic_search_subnets_suffix = "ElasticSearch"


  tags = {
    Owner       = "Aashish"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}

##################################################################
# Application Load Balancer
##################################################################
module "alb" {
  source = "./terraform-aws-alb"

  #name = "complete-alb-${random_pet.this.id}"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  security_groups = ["${aws_security_group.els_sg_magento_public.id}"]
  subnets         = module.vpc.alb_subnets #data.aws_subnet_ids.all.ids



  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]


  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = "80"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },

  ]



}

module "ec2_ssh" {
  source = "./terraform-aws-ec2-instance"

  instance_count = 1

  name                        = "SG-Magento-SSH"
  ami                         = "ami-034d940df32c75d15"
  instance_type               = "t2.micro"
  key_name                    = "hi"
  subnet_id                   = module.vpc.ssh_subnets[0] # tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = ["${aws_security_group.els_sg_magento_public.id}", "${aws_security_group.comp_access_sg.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  #placement_group             = aws_placement_group.web.id
#  private_key_path = "/home/aashish/aashish-demo"



  tags = {
    "Env"      = "SSH"
    "Location" = "SSH_Subnet"
  }
}

module "ec2_magento1" {
  source = "./terraform-aws-ec2-instance"

  instance_count = 1

  name                        = "Magento2Prodweb1"
  ami                         = "ami-034d940df32c75d15"
  instance_type               = "t2.micro"
  key_name                    = "Magento2Prodweb1"
  subnet_id                   = module.vpc.WebServer_subnets[0] # tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = ["${aws_security_group.els_sg_magento_public.id}"]
  associate_public_ip_address = false
  source_dest_check           = false
  user_data                   = "${file("install.sh")}"
  #placement_group             = aws_placement_group.web.id



  tags = {
    "Env"      = "Private"
    "Location" = "Secret"
  }
}


module "ec2_magento2" {
  source = "./terraform-aws-ec2-instance"

  instance_count = 1

  name                        = "Magento2Prodweb2"
  ami                         = "ami-034d940df32c75d15"
  instance_type               = "t2.micro"
  key_name                    = "Magento2Prodweb2"
  subnet_id                   = module.vpc.WebServer_subnets[1] # tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = ["${aws_security_group.els_sg_magento_public.id}"]
  associate_public_ip_address = false
  source_dest_check           = false
  user_data                   = "${file("install.sh")}"
  #placement_group             = aws_placement_group.web.id



  tags = {
    "Env"      = "Private"
    "Location" = "Secret"
  }
}





resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = module.alb.target_group_arns[0]
 #target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id = module.ec2_magento1.id[0]
  port      = 80
}



resource "aws_alb_target_group_attachment" "alb_backend-02_http" {
  target_group_arn = module.alb.target_group_arns[0]
 #target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id = module.ec2_magento2.id[0]
  port      = 80
}

      