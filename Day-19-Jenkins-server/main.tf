
# Generate a private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair using the generated public key
resource "aws_key_pair" "ec2_keypair" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# # Save private key locally
# resource "local_file" "private_key" {
#   content         = tls_private_key.ec2_key.private_key_pem
#   filename        = "${path.module}/my-ec2-key.pem"
#   file_permission = "0400"
# }

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = pathexpand("~/Downloads/my-ec2-key.pem")
}

# Security Group for SSH access
resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"

  ingress {
    description = "All access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  ami                    = var.ami_id 
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_keypair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install java-21-amazon-corretto -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              yum install git -y
              EOF

  tags = {
    Name = "jenkins"
  }
}