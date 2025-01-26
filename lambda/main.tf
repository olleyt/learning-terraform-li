# S3 Bucket
resource "aws_s3_bucket" "tf-lambda-s3-events-260125-bucket" {
  bucket = "my-input-bucket"  # Change to your desired bucket name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.tf-lambda-s3-events-260125-bucket.id

  eventbridge = true
}
