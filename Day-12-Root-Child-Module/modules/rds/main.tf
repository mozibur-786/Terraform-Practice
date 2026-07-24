resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db-subnet-group"
    subnet_ids = [var.subnet1_id , var.subnet2_id]
    tags = {
      Name = "my-db-subnet-group"
    }
  
}

resource "aws_db_instance" "db_instance" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0"
    instance_class = var.instance_class
    identifier = var.db_identifier
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    skip_final_snapshot = true
  
}