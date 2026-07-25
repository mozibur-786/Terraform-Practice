resource "aws_instance" "name" {
    ami = "ami-06067086cf86c58e6"
    instance_type = "t2.micro"

    tags = {
      Name = "aizen"
    }
  
}

resource "aws_s3_bucket" "name" {
  bucket = "aizen-s3-buckett-india"
}

# we can target specific resource to update or destroy by using -target option in terraform paln and apply.
# terraform plan -target=aws_s3_bucket.name

# to target multiple resources 
# terraform plan -target=aws_s3_bucket.name -target=aws_instance.name