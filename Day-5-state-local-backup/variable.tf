variable "aizen_vpc_id" {
  description = "vpc for aizen"
  default     = ""
  type = string
}
variable "aizen_subnet_id" {
  description = "subnet for aizen"
  default     = ""
  type = string
}
variable "aizen_sg_id" {
  description = "security group for aizen"
  default     = ""
  type = string
}
variable "aizen_ami_id" {
  description = "ami id for aizen"
  default     = ""
  type = string
}
variable "aizen_instance_type" {
  description = "instance type for aizen"
  default     = ""
  type = string
}