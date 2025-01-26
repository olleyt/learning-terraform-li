variable "bucket_name" {
    description = "name of the bucket"
    default = "tf-bucket-lambda-s3-events-260125"
}

variable "input_folder" {
  description = "Folder path in S3 bucket to monitor for events"
  type        = string
  default     = "input/"
}