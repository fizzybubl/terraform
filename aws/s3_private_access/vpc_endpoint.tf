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


resource "aws_security_group" "instance_connect" {
  name = "InstanceConnectSG"
  tags = {
    "Name": "InstanceConnectSG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "internet_inbound" {
  security_group_id = aws_security_group.instance_connect.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "vpc_outbound" {
  security_group_id = aws_security_group.instance_connect.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.private_vpc.cidr_block
}


resource "aws_ec2_instance_connect_endpoint" "ep" {
  subnet_id = module.subnet_2.subnet_id
  security_group_ids = [aws_security_group.instance_connect.id]
}