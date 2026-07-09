output "public_ip_aizen" {
  value = aws_instance.aizen.public_ip
}
output "private_ip_aizen" {
  value = aws_instance.aizen.private_ip
}
output "public_ip_ichigo" {
  value = aws_instance.ichigo.public_ip
}
output "private_ip_ichigo" {
  value = aws_instance.ichigo.private_ip
}
output "public_ip_renji" {
  value = aws_instance.renji.public_ip
}
output "private_ip_renji" {
  value = aws_instance.renji.private_ip
}