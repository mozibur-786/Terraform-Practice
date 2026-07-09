resource "aws_instance" "aizen" {
  ami = var.aizen_ami_id
  instance_type = var.aizen_instance_type
  tags = {
    Name = "aizen's instance"
  }
}

resource "aws_instance" "ichigo" {
  ami = var.ichigo_ami_id
  instance_type = var.ichigo_instance_type
  tags = {
    Name = "ichigo's instance"
  } 
}

resource "aws_instance" "renji" {
  ami = var.renji_ami_id
  instance_type = var.renji_instance_type
  tags = {
    Name = "renji's instance"
  }
}