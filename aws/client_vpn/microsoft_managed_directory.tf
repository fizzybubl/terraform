
locals {
  subnet_az_ids = [for idx in range(length(local.az_ids)) : local.az_ids[idx]]
}


# resource "aws_directory_service_directory" "simple_ad" {
#   name     = "corp.example.com"
#   password = var.admin_password
#   size     = "Small"
#   type = "SimpleAD"

#   vpc_settings {
#     vpc_id     = module.cloud_vpc.vpc_id
#     subnet_ids = [for subnet_az_id in local.subnet_az_ids: module.cloud_app[subnet_az_id].subnet_id]
#   }
# }
