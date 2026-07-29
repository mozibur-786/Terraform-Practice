variable "allowed_ports" {
    type = map(string)
    default = {
      22   = "203.0.113.0/24"     # SSH (Restrict to office IP)
      80   = "0.0.0.0/0"          # HTTP (public)
      443  = "0.0.0.0/0"          # HTTPS (public)
      8080 = "10.0.0.0/16"        # Internal App (restrict to VPC)
      9000 = "192.168.1.0/24"     # SonarQube/jenkins (Restrict to VPN)
      3389 = "10.0.1.0/24"
    }
  
}

resource "aws_security_group" "my_sg" {
    name = "my-sg-rules"
    description = "inbound rules"

    dynamic "ingress" {
        for_each = var.allowed_ports
        content {
          description = "Allow access to port ${ingress.key}"
          from_port   = ingress.key
          to_port     = ingress.key
          protocol    = "tcp"
          cidr_blocks = [ingress.value]
        }
      
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "my-sg-rules"
    }
  
}