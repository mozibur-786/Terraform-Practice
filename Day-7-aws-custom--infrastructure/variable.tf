variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  default     = ""
  type        = string
}
variable "instance_type" {
  description = "The type of instance to create"
  default     = ""
  type        = string
}
