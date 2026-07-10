output "vpc_id" {
  value = aws_vpc.aizen_vpc.id
}
output "subnet_id" {
  value = aws_subnet.aizen_subnet.id
}
output "sg_id" {
  value = aws_security_group.aizen_security_group.id
}
output "instance_id" {
  value = aws_instance.aizen_instance.id
}
output "instance_public_ip" {
  value = aws_instance.aizen_instance.public_ip
}
output "instance_private_ip" {
  value = aws_instance.aizen_instance.private_ip
}
