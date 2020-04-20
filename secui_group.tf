# Define the security group for complete access
resource "aws_security_group" "complete_access_sg" {
  name        = "complete_access_sg"
  description = "Allow complete traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "complete_access_sg"
  }
}

# Define the security group for Magento
resource "aws_security_group" "els_sg_magento_public" {
  name        = "els_magento_sg"
  description = "Allow complete traffic"


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "els_magento_sg"
  }
}
# Define the security group for Magento
resource "aws_security_group" "comp_access_sg" {
  name        = "ssh_server_sg"
  description = "Allow complete traffic"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "ssh_server_sg"
  }
}
