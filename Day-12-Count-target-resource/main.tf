variable "aizen" {
    type = bool
    default = true
  
}

resource "aws_instance" "name" {
    ami = "ami-06067086cf86c58e6"
    instance_type = "t2.micro"
    count = var.aizen ? 1 : 0

    tags = {
      Name = "aizen-instance"
    }
  
}
# if the variable aizen is true then create 1 instance anf if false create 0 instance.