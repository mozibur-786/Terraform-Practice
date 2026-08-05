resource "aws_instance" "name" {
    ami = "ami-0bdc7d025135d7b49"
    instance_type = "t2.micro"

    tags = {
        Name = "test"
    }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "rohit-test-buck"
  
}
resource "aws_s3_bucket_versioning" "name" {
    bucket = aws_s3_bucket.name.bucket
    versioning_configuration {
      status = "Enabled"
    }
  
}