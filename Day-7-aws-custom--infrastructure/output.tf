output "vpc_id" {
  value = aws_vpc.aizen.id
}
output "public_subnet_id" {
  value = aws_subnet.aizen-public-subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.aizen-private-subnet.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.aizen_igw.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.aizen_nat_gateway.id
}
output "public_route_table_id" {
  value = aws_route_table.aizen_route_table.id
}
output "private_route_table_id" {
  value = aws_route_table.aizen_private_route_table.id
}
output "elastic_ip_id" {
  value = aws_eip.aizen_nat_eip.id
}
output "public_server_instance_id" {
  value = aws_instance.aizen_public_instance.id
}
output "private_server_instance_id" {
  value = aws_instance.aizen_private_instance.id
}
output "public_instance_public_ip" {
  value = aws_instance.aizen_public_instance.public_ip
}
output "public_instance_private_ip" {
  value = aws_instance.aizen_public_instance.private_ip
}
output "private_instance_public_ip" {
  value = aws_instance.aizen_private_instance.public_ip
}
output "private_instance_private_ip" {
  value = aws_instance.aizen_private_instance.private_ip
}