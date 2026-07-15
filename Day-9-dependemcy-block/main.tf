# Iam policy for s3 acccess

resource "aws_iam_policy" "ec2_s3_access" {
  name = "ec2-s3-access"
  description = "allow ec2 to access all s3 buckets."

  policy =  jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ]
            Resource = [
                "arn:aws:s3:::my-bucket",
                "arn:aws:s3:::my-bucket/*"
            ]
        }
    ]
  })
}

# Iam role for EC2

resource "aws_iam_role" "ec2_s3_access" {
    name = "ec2-s3-access"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

# Attaching policy with role

resource "aws_iam_role_policy_attachment" "my_policy_attachment" {
    role = aws_iam_role.ec2_s3_access.name
    policy_arn = aws_iam_policy.ec2_s3_access.arn
}

# creating profile for ec2 to use the rule

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2-instance-profile"
    role = aws_iam_role.ec2_s3_access.name
}

#Launching a ec2 instance

resource "aws_instance" "ec2_instance" {
    ami = "ami-06067086cf86c58e6"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    tags = {
        Name = "Aizen"
    }
}

# launching a s3 bucket 

resource "aws_s3_bucket" "my_s3" {
    bucket = "rohit-s3-bucket-india"
    depends_on = [ aws_instance.ec2_instance ]
    # This tells terraform to create s3 after the ec2 is  created.
}

