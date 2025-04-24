output "dev_endpoint" {
  value = aws_s3_bucket_website_configuration.dev.website_endpoint
}


output "prod_endpoint" {
  value = aws_s3_bucket_website_configuration.prod.website_endpoint
}