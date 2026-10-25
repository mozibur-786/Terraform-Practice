
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

resource "aws_iam_role" "my_iam_role" {
  name = "ec2-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
}

resource "aws_iam_role_policy_attachment" "my_iam_policy_attachment" {
  role       = aws_iam_role.my_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_instance_profile" "my_iam_instance_profile" {
  name = "my-iam-instance-profile"
  role = aws_iam_role.my_iam_role.name
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  ami                    = var.ami_id 
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_keypair.key_name
  iam_instance_profile = aws_iam_instance_profile.my_iam_instance_profile.name
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
              sudo yum install git -y
              sudo yum install -y yum-utils shadow-utils
              sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              sudo yum install terraform -y
              EOF

  tags = {
    Name = "jenkins"
  }
}