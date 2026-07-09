resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "aizen"
    }
  
}

resource "aws_subnet" "name" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.1.0/24"
    
    tags = {
        Name = "aizen's subnet"
    }
}

resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    tags = {
        Name = "aizen's instance"
    }
}