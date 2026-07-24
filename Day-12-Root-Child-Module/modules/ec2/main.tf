resource "aws_instance" "my_ec2"{
    ami =   var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet1_id

    tags = {
      Name = "my-instance"
    }
}