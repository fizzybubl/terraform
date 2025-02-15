# resource "aws_directory_service_directory" "managed_ad" {
#   count                                = var.directory_type == "MicrosoftAD" ? 1 : 0
#   name                                 = "corp.example.com"
#   password                             = var.admin_password
#   edition                              = "Standard"
#   desired_number_of_domain_controllers = 2

#   vpc_settings {
#     vpc_id     = ""
#     subnet_ids = []
#   }
# }


# resource "aws_directory_service_directory" "simple_ad" {
#   count    = var.directory_type == "SimpleAD" ? 1 : 0
#   name     = "corp.example.com"
#   password = var.admin_password
#   size     = "Small"

#   vpc_settings {
#     vpc_id     = ""
#     subnet_ids = []
#   }
# }


# resource "aws_directory_service_directory" "ad_connector" {
#   count    = var.directory_type == "ADConnector" ? 1 : 0
#   name     = "corp.example.com"
#   password = var.admin_password
#   size     = "Small"

#   connect_settings {
#     customer_dns_ips  = []
#     customer_username = ""
#     vpc_id            = ""
#     subnet_ids        = []
#   }
# }