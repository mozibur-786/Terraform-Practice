module "vpc" {
    source       = "./modules/vpc"
    vpc_cidr   = "10.0.0.0/16"
    subnet1_cidr = "10.0.1.0/24"
    subnet2_cidr = "10.0.2.0/24"
    az1          = "us-east-1a"
    az2          = "us-east-1b"
  
}

module "ec2" {
    source = "./modules/ec2"
    ami_id = "ami-06067086cf86c58e6"
    instance_type = "t2.micro"
    subnet1_id = module.vpc.subnet1_id
  
}

module "rds" {
    source = "./modules/rds"
    subnet1_id = module.vpc.subnet1_id
    subnet2_id = module.vpc.subnet2_id
    instance_class = "db.t3.micro"
    db_name = "mydb"
    db_password = "admin12345"
    db_username = "admin"
    db_identifier = "my-db"
  
}

module "s3" {
    source = "./modules/s3"
    bucket =    "rohit-devops-bhadrak"
  
}