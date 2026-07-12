#vpc creation
resource "aws_vpc" "aizen" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aizen-vpc"
  }
}

#public subnet
resource "aws_subnet" "aizen-public-subnet" {
  vpc_id            = aws_vpc.aizen.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "aizen-public-subnet"
  }
}

#private subnet
resource "aws_subnet" "aizen-private-subnet" {
  vpc_id            = aws_vpc.aizen.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "aizen-private-subnet"
  }
}

#internet gateway for public subnet
resource "aws_internet_gateway" "aizen_igw" {
  vpc_id = aws_vpc.aizen.id
  tags = {
    Name = "aizen-igw"
  }
}

#route table for public subnet
resource "aws_route_table" "aizen_route_table" {
  vpc_id = aws_vpc.aizen.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aizen_igw.id
  }
}

#connecting public subnet to route table
resource "aws_route_table_association" "aizen_route_table_association" {
  subnet_id      = aws_subnet.aizen-public-subnet.id
  route_table_id = aws_route_table.aizen_route_table.id
}

#elastic ip for nat gateway
resource "aws_eip" "aizen_nat_eip" {
  domain = "vpc"
}

#nat gateway for private subnet
resource "aws_nat_gateway" "aizen_nat_gateway" {
  allocation_id = aws_eip.aizen_nat_eip.id
  subnet_id     = aws_subnet.aizen-public-subnet.id
}

#route table for private subnet 
resource "aws_route_table" "aizen_private_route_table" {
  vpc_id = aws_vpc.aizen.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.aizen_nat_gateway.id
  }
}

#connecting private subnet to route table
resource "aws_route_table_association" "aizen_private_route_table_association" {
  subnet_id      = aws_subnet.aizen-private-subnet.id
  route_table_id = aws_route_table.aizen_private_route_table.id
}

#security group for allowing all traffic
resource "aws_security_group" "aizen_sg" {
  name        = "aizen-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.aizen.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#launching ec2 instance in public subnet
resource "aws_instance" "aizen_public_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.aizen-public-subnet.id
  associate_public_ip_address = true
  key_name        = "aizen_key"
  vpc_security_group_ids = [aws_security_group.aizen_sg.id]
  tags = {
    Name = "aizen-public-instance"
  }
}

#launching ec2 instance in private subnet
resource "aws_instance" "aizen_private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.aizen-private-subnet.id
  associate_public_ip_address = false
  key_name        = "aizen_key"
  vpc_security_group_ids = [aws_security_group.aizen_sg.id]
  tags = {
    Name = "aizen-private-instance"
  }
}