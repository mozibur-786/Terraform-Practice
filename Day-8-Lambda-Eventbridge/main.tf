resource "aws_s3_bucket" "my_bucket" {
  bucket = "rohit-devops-india" # Replace with a unique bucket name
  region = "us-east-1" # Replace with your desired region
}

resource "aws_s3_object" "my_lambda_zip" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "lambda/lambda_function.zip"
  source = "lambda_function.zip"
  etag   = filemd5("lambda_function.zip")
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda-eventbridge"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
}

resource "aws_iam_policy_attachment" "lambda_iam_policy_attachment" {
  name       = "lambda-iam-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_iam_role.name]
}

resource "aws_iam_policy_attachment" "s3_access_policy_attachment" {
  name       = "s3-access-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  roles      = [aws_iam_role.lambda_iam_role.name]
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my-lambda-eventbridge"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"
  timeout       = 900
  memory_size   = 128
  #filename = "lambda_function.zip"

  # code will be taken from the S3 bucket.
  s3_bucket = aws_s3_bucket.my_bucket.bucket
  s3_key    = aws_s3_object.my_lambda_zip.key

  source_code_hash = filebase64sha256("lambda_function.zip")

  # Without source code hash, Terraform will not detect changes in the Lambda function code and will not update the function when the code changes.
  # The source_code_hash ensures that Terraform can track changes to the deployment package and update the Lambda function accordingly.
  
}

  # Create eventbridge rule (schedule)
  resource "aws_cloudwatch_event_rule" "every_5_minutes" {
    name = "every-five-minutes"
    description = "trigger lambda every five minutes"
    schedule_expression = "rate(5 minutes)"
    
  }

  # Add lambda target
  resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.every_5_minutes.name
    target_id = "lambda"
    arn = aws_lambda_function.my_lambda_function.arn
    
  }

  # Allow eventbridge to invoke the lambda
  resource "aws_lambda_permission" "allow_event_bridge" {
    statement_id = "allow-execution-from-eventbridge"
    action = "lambda:Invokefunction"
    function_name = aws_lambda_function.my_lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_5_minutes.arn
    
  }

