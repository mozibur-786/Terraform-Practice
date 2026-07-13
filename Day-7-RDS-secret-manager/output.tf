output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "subnet1_id" {
  value = aws_subnet.subnet1.id
}
output "subnet2_id" {
  value = aws_subnet.subnet2.id
}
output "db_instance_endpoint" {
  value = aws_db_instance.my_db_instance.endpoint
}
output "read_replica_endpoint" {
  value = aws_db_instance.read_replica.endpoint
}
