resource "aws_instance" "name" {
    ami = "ami-06067086cf86c58e6"
    instance_type = "t2.micro"


    lifecycle {
      create_before_destroy = true
    }

    # lifecycle {
    #   ignore_changes = [ tags ]
    # }

    # lifecycle {
    #   prevent_destroy = true
      
    # }

    tags = {
      Name = "rohit-instance"
    }
  
}