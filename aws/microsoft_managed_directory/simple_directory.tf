resource "aws_directory_service_directory" "simple_ad" {
  count    = var.directory_type == "SimpleAD" ? 1 : 0
  name     = "corp.example.com"
  password = var.admin_password
  size     = "Small"

  vpc_settings {
    vpc_id     = ""
    subnet_ids = []
  }
}