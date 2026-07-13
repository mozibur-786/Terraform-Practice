resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

  resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-1"
  }
  }

  resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-2"
  }
  }

  resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-subnet-group"
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }




  resource "aws_db_instance" "my_db_instance" {
    allocated_storage    = 20
    db_name               = "mydb"
    engine                = "mysql"
    engine_version        = "8.0"
    instance_class        = "db.t3.micro"
    username              = "admin"
    #manage_master_user_password = true # rds ans secret manager will manage the password
    password              = "rohit123"
    db_subnet_group_name = aws_db_subnet_group.my_subnet_group.name
    parameter_group_name  = "default.mysql8.0"

    # Enable backup and retention settings
    backup_retention_period = 7    # Retain backups for 7 days
    backup_window           = "03:00-04:00"   # Daily backup window (UTC time)

    # Enable monitoring (CloudWatch enhanced monitoring)
    # monitoring_interval = 60  # Collect metrics every 60 seconds
    # monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

    # Enable performance insights
    # performance_insights_enabled = true
    # performance_insights_retention_period = 7  # Retain performance insights data for 7 days

    # Enable maintenance window
    maintenance_window = "Sun:05:00-Sun:06:00"  # Maintenance every Sunday (UTC time)

    # Enable deletion protection (optional, but recommended for production to prevent acceidental deletion)
    deletion_protection = true

    # Skip final snapshot on deletion (optional, but recommended for production to prevent data loss)
    skip_final_snapshot = true
    tags = {
      Name = "my-db-instance"
    }
  }



  # Iam role for RDS monitoring
    # resource "aws_iam_role" "rds_monitoring_role" {
    #     name = "rds-monitoring-role"
    
    #     assume_role_policy = jsonencode({
    #     Version = "2012-10-17"
    #     Statement = [
    #         {
    #         Action = "sts:AssumeRole"
    #         Effect = "Allow"
    #         Principal = {
    #             Service = "monitoring.rds.amazonaws.com"
    #         }
    #         },
    #     ]
    #     })
    # }


    # # Iam attach policy to the role for RDS monitoring
    # resource "aws_iam_role_policy_attachment" "rds_monitoring_policy_attachment" {
    #     role       = aws_iam_role.rds_monitoring_role.name
    #     policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
    # }

    # RDS read replica for high availability
    resource "aws_db_instance" "read_replica" {
  identifier          = "my-read-replica"
  replicate_source_db = aws_db_instance.my_db_instance.identifier

  instance_class      = "db.t3.micro"

  tags = {
    Name = "ReadReplica"
  }
}

