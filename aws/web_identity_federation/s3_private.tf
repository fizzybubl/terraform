module "privatepatches" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "privatepatches-"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
  force_destroy           = true
}


resource "aws_s3_object" "patches" {
  count = 3
  bucket = module.cloudfront.bucket.id
  key = "patches${count.index + 1}.jpg"
  source = "${path.module}/files/photos/patches${count.index + 1}.jpg"
}