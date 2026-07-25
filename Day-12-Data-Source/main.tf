data "aws_subnet" "name" {
    filter {
      name = "tag:Name"
      values = [ "aizen-subnet" ]
    }
  
}




data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  subnet_id = data.aws_subnet.name.id
  instance_type = "t2.micro"

  tags = {
    Name = "aizen-ec2"
  }
}