resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    for_each = toset(var.instance_name)
    tags = {
      Name = each.key
    }
  
}