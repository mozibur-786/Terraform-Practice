locals {
  ami_id = "ami-06067086cf86c58e6"
instance_type = "t2.medium"

}

resource "aws_instance" "instance_1" {
    ami = local.ami_id
    instance_type = local.instance_type
    tags = {
      Name = "Aizen"
    }
}

resource "aws_instance" "instance_2" {
    ami = local.ami_id
    instance_type = local.instance_type
    tags = {
      Name = "Ichigo"
    }
}