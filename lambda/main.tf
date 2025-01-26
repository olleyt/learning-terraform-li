# S3 Bucket
resource "aws_s3_bucket" "${var.bucket_name}" {
  bucket = "my-input-bucket"  # Change to your desired bucket name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.var.bucket_name.id

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
        name = [aws_s3_bucket.var.bucket_name.id]
      }
      object = {
        key = [{
          prefix = "input-folder/"  # Change to your desired folder path
        }]
      }
    }
  })
}
