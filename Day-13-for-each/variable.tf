variable "ami_id" {
    description = "ami id for instance"
    default = ""
    type = string
}
variable "instance_type" {
    description = "instance type for instance"
    default = ""
    type = string
}
variable "instance_name" {
    description = "different names for the instances"
    type = list(string)
}