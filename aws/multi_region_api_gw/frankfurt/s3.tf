data "aws_caller_identity" "current_user" {

}

// TODO: Add S3 bucket + S3 object upload, to be used in lambda function as source code


resource "aws_s3_bucket" "source" {
  bucket = "lambda-s3-source-bucket"
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/files/lambda.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.source.id
  key = "lambda-code/dev/lambda.py"
  source = "${path.module}/lambda_function_payload.zip"
}