variable "ami_id" {
  description = "ami id for the instance"
default     = "ami-06067086cf86c58e6"
  type = string
}

variable "instance_type" {
  description = "instance type for the instance"
  default     = "t2.micro"
  type = string
}

variable "vpc_id" {
  description = "vpc id for the instance"
  default     = "vpc-06a996e18762653c6"
  type = string
}

variable "subnet_id" {
  description = "subnet id for the instance"
  default     = "subnet-094839f7852450f79"
  type = string
}