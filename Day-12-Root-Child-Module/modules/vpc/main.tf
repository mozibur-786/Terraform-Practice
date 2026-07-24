resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
      Name = "my-vpc"
    }
  
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.az1

    tags = {
      Name = "my-subnet1"
    }
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.subnet2_cidr
    availability_zone = var.az2

    tags = {
      Name = "my-subnet2"
    }
  
}