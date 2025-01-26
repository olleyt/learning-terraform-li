# S3 Bucket
resource "aws_s3_bucket" "input_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.input_bucket.id

  eventbridge = true
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "s3_event" {
  name        = "capture-s3-events"
  description = "Capture S3 events for specific folder"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [aws_s3_bucket.input_bucket.id]
      }
      object = {
        key = [{
          prefix = var.input_folder
        }]
      }
    }
  })
}

# Lambda Function using AWS Lambda Module
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  function_name = "s3-event-processor"
  description   = "Lambda function to process S3 events"
  handler       = "index.handler"
  runtime       = "python3.11"

  source_path = "./src"

  create_role = false
  lambda_role = aws_iam_role.lambda_role.arn

  environment_variables = {
    BUCKET_NAME = aws_s3_bucket.input_bucket.id
    INPUT_FOLDER = var.input_folder
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.s3_event.name
  target_id = "SendToLambda"
  arn       = module.lambda_function.lambda_function_arn
}

# Lambda permission for EventBridge
resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_event.arn
}
