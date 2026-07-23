module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "aizen-demo-rds"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  family = "mysql8.0"
  major_engine_version = "8.0"

  db_name  = "mydb"
  username = "admin"
  password = "rohit1234"

  publicly_accessible = true
  skip_final_snapshot = true
}