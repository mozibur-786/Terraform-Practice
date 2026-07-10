resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aizen"
  }
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "aizen's subnet"
  }
}
resource "aws_subnet" "name1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "aizen's subnet 1"
  }
}