data "aws_iam_role" "admin_dev" {
  name     = "Administrator"
  provider = aws.dev
}

data "aws_iam_role" "admin_prod" {
  name     = "Administrator"
  provider = aws.prod
}

data "aws_caller_identity" "current" {
  provider = aws.dev
}

module "dev" {
  source                  = "../s3/modules/bucket"
  bucket                  = "destination-dev-test-sdd"
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
  versioning              = "Enabled"
  providers = {
    aws = aws.dev
  }
}


module "prod" {
  source                  = "../s3/modules/bucket"
  bucket                  = "source-prod-test-sdd"
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
  versioning              = "Enabled"
  providers = {
    aws = aws.prod
  }
}


resource "aws_s3_bucket_policy" "dev" {
  provider = aws.dev
  bucket   = module.dev.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow Admin"
        "Principal" : {
          "AWS" : "${data.aws_iam_role.admin_dev.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : ["${module.dev.bucket.arn}", "${module.dev.bucket.arn}/*"]
      },
      {
        "Sid" : "Set-permissions-for-objects",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.allow_prod_to_replicate_to_dev.arn
        },
        "Action" : ["s3:ReplicateObject", "s3:ReplicateDelete"],
        "Resource" : "${module.dev.bucket.arn}/*"
      },
      {
        "Sid" : "Set permissions on bucket",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.allow_prod_to_replicate_to_dev.arn
        },
        "Action" : ["s3:GetBucketVersioning", "s3:PutBucketVersioning"],
        "Resource" : "${module.dev.bucket.arn}"
      },
      {
        "Sid" : "Allow getObject public",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject"],
        "Resource" : "${module.dev.bucket.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_policy" "prod" {
  provider = aws.prod
  bucket   = module.prod.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow Admin"
        "Principal" : {
          "AWS" : "${data.aws_iam_role.admin_prod.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : ["${module.prod.bucket.arn}", "${module.prod.bucket.arn}/*"],
      },
      {
        "Sid" : "Allow getObject public",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject"],
        "Resource" : "${module.prod.bucket.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_replication_configuration" "prod_to_dev" {
  provider = aws.prod
  role     = aws_iam_role.allow_prod_to_replicate_to_dev.arn
  bucket   = module.prod.bucket.id

  rule {
    id = "replicate-all"

    filter {}

    status = "Enabled"

    destination {
      bucket        = module.dev.bucket.arn
      storage_class = "STANDARD"
      account       = data.aws_caller_identity.current.account_id

      access_control_translation {
        owner = "Destination"
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [aws_s3_bucket_policy.prod, aws_s3_bucket_policy.dev]
}


resource "aws_s3_object" "jpg" {
  provider     = aws.prod
  bucket       = module.prod.bucket.id
  key          = "aotm.jpg"
  content_type = "image/jpeg"
  source       = "${path.module}/files/${var.website_version}/aotm.jpg"

  depends_on = [aws_s3_bucket_replication_configuration.prod_to_dev]
}


resource "aws_s3_object" "html" {
  provider     = aws.prod
  bucket       = module.prod.bucket.id
  key          = "index.html"
  content_type = "text/html"
  source       = "${path.module}/files/${var.website_version}/index.html"

  depends_on = [aws_s3_bucket_replication_configuration.prod_to_dev]
}


resource "aws_s3_bucket_website_configuration" "prod" {
  provider = aws.prod
  bucket   = module.prod.bucket.id

  index_document {
    suffix = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "home/"
    }
    redirect {
      replace_key_prefix_with = "/"
    }
  }
}


resource "aws_s3_bucket_website_configuration" "dev" {
  provider = aws.dev
  bucket   = module.dev.bucket.id

  index_document {
    suffix = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "home/"
    }
    redirect {
      replace_key_prefix_with = "/"
    }
  }
}

