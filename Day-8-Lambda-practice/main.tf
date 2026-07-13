resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda-execution-role"
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

resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my-lambda-function"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"
  timeout       = 900
  memory_size   = 128
  filename     = "lambda_function.zip"
  

  source_code_hash = filebase64sha256("lambda_function.zip")

  # Without source code hash, Terraform will not detect changes in the Lambda function code and will not update the function when the code changes.
  # The source_code_hash ensures that Terraform can track changes to the deployment package and update the Lambda function accordingly.
  
}

