resource "aws_vpc" "aizen_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aizen_vpc"
  }
}

resource "aws_subnet" "aizen_subnet" {
  vpc_id            = var.aizen_vpc_id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "aizen_subnet"
  }
}

resource "aws_security_group" "aizen_security_group" {
  vpc_id = var.aizen_vpc_id

description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "aizen_security_group"}

}

resource "aws_instance" "aizen_instance" {
  ami           = var.aizen_ami_id
  instance_type = var.aizen_instance_type
  subnet_id     = var.aizen_subnet_id
  vpc_security_group_ids = [var.aizen_sg_id]
  associate_public_ip_address = true
  tags = {
    Name = "aizen_instance"
  }
  
}