resource "aws_iam_role" "allow_frankfurt_to_replicate_to_dublin" {
  name = "AllowFrankfurtToReplicateToDublin"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Name" : "AllowFrankfurtToReplicateToDublin"
  }
}

resource "aws_iam_policy" "allow_frankfurt_to_replicate_to_dublin" {
  policy = templatefile("${path.module}/files/replication_policy.tpl.json", {
    source_bucket_arn      = module.frankfurt.bucket.arn
    destination_bucket_arn = module.dublin.bucket.arn
  })

  tags = {
    "Name" : "AllowFrankfurtToReplicateToDublin"
  }
}


resource "aws_iam_role_policy_attachment" "allow_frankfurt_to_replicate_to_dublin" {
  role       = aws_iam_role.allow_frankfurt_to_replicate_to_dublin.name
  policy_arn = aws_iam_policy.allow_frankfurt_to_replicate_to_dublin.arn
}


resource "aws_iam_role" "allow_dublin_to_replicate_to_frankfurt" {
  name = "AllowDublinToReplicateToFrankfurt"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Name" : "AllowDublinToReplicateToFrankfurt"
  }
}

resource "aws_iam_policy" "allow_dublin_to_replicate_to_frankfurt" {
  policy = templatefile("${path.module}/files/replication_policy.tpl.json", {
    source_bucket_arn      = module.dublin.bucket.arn
    destination_bucket_arn = module.frankfurt.bucket.arn
  })

  tags = {
    "Name" : "AllowDublinToReplicateToFrankfurt"
  }
}


resource "aws_iam_role_policy_attachment" "allow_dublin_to_replicate_to_frankfurt" {
  role       = aws_iam_role.allow_dublin_to_replicate_to_frankfurt.name
  policy_arn = aws_iam_policy.allow_dublin_to_replicate_to_frankfurt.arn
}