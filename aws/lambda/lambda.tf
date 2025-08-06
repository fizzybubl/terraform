module "lambda" {
  source        = "./modules/lambda"
  function_name = "efs-private-lambda"
  alias_name    = "dev"
  handler       = "lambda.lambda_handler"

  s3_bucket = "lambda-source-bucket-test-efs"
  s3_key    = "dev/lambda.zip"

  efs_arn          = module.efs.access_point_arn
  local_mount_path = "/mnt/efs"

  security_group_ids = [module.lambda_sg.sg_id]
  subnet_ids         = [module.cloud_app[local.az2].subnet_id, module.cloud_app[local.az3].subnet_id]

  execution_role_arn = aws_iam_role.lambda_exec_role.arn
}