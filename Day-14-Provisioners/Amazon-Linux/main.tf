# key pair
resource "aws_key_pair" "my_key" {
    key_name   = "my_key"
    public_key = file("~/.ssh/id_rsa.pub")  
}

# vpc
resource "aws_vpc" "my_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      Name = "my-vpc"
    }
}
  
# subnet
resource "aws_subnet" "my_subnet" {
    cidr_block              = "10.0.0.0/24"
    vpc_id                  = aws_vpc.my_vpc.id
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "my-subnet"
    }
}

# internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
}

# route table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    } 
    tags = {
      Name = "my-rt"
    }
}

# association route table
resource "aws_route_table_association" "my_rta" {
    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my-rt.id 
}

# securirty group
resource "aws_security_group" "my_sg" {
    name        = "my-sg"
    description = "allow ssh and http"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        description = "allow http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name ="my-sg"
    }
}

# ec2 instance (amazon linux)
resource "aws_instance" "my_ec2" {
    ami                         = var.ami_id   # amazon linux ami
    instance_type               = var.instance_type
    key_name = aws_key_pair.my_key.key_name
    subnet_id                   = aws_subnet.my_subnet.id
    vpc_security_group_ids      = [aws_security_group.my_sg.id]
    associate_public_ip_address = true
    tags = {
      Name = "amazon linux server"
    }

    # connection {
    #   type = "ssh"
    #   user = "ec2-user"
    #   private_key = file("~/.ssh/id_rsa")
    #   host = self.public_ip
    #   timeout = "2m"
    # }

    # provisioner "file" {
    #     source = "file10"
    #     destination = "/home/ec2-user/file10"
    # }

    # provisioner "remote-exec" {
    #     inline = [ 
    #         "touch /home/ec2-user/file200",
    #         "echo 'hello from rohit' >> /home/ec2-user/file200"
    #      ]
    # }

    # provisioner "local-exec" {
    #     command = "touch file500"
      
    # }

}

# null resource
resource "null_resource" "run_script" {
    provisioner "remote-exec" {
        connection {
          host = aws_instance.my_ec2.public_ip
          user = "ec2-user"
          private_key = file("~/.ssh/id_rsa")
        }

        inline = [ 
            "echo 'hello from rohit' >> /home/ec2-user/file20"
         ]
      
    }

    triggers = {
         always_run = "${timestamp()}"   # forces rerun everytime
     }
  
}
