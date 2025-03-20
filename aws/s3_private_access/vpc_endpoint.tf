resource "aws_vpc_endpoint" "private_s3" {
  vpc_id       = module.private_vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
}


resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  route_table_id  = module.subnet_1.route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.private_s3.id
}


resource "aws_vpc_endpoint_policy" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.private_s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAllToCatBuckets",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*"
        ],
        "Resource" : ["${module.private.bucket.arn}/*", "${module.public.bucket.arn}/*"]
      },
      {
        "Sid" : "AllowListAllObjectsInBuckets",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:ListBucket"],
        "Resource" : [module.private.bucket.arn, module.public.bucket.arn]
      },
      {
        "Sid" : "AllowListAllBuckets",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:ListAllMyBuckets", "s3:GetBucketLocation"],
        "Resource" : "*"
      }
    ]
  })
}