
resource "aws_directory_service_directory" "simple_ad" {
  name     = "corp.example.com"
  password = var.admin_password
  size     = "Small"
  type     = "SimpleAD"

  vpc_settings {
    vpc_id     = module.cloud_vpc.vpc_id
    subnet_ids = [for az_id in local.az_ids : module.cloud_db[az_id].subnet_id if az_id != local.az_ids[0]]
  }
}
