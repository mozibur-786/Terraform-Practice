# resource "aws_instance" "name" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     count = 3

#     tags = {
#       Name = "aizen"         # 3 instances will be created but with same name
#     }
  
# }


# resource "aws_instance" "name" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     count = 3
#     tags = {
#       Name = "aizen-${count.index}"   # now the instance will get the numbers like aizen-0, aizen-1
#     }
  
# }


resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  count = length(var.instance_name)

  tags = {
    Name = var.instance_name[count.index]   # 3 instances will be created with different names
  }
  
}