data "aws_caller_identity" "dev" {
  provider = aws.dev
}


data "aws_caller_identity" "prod" {
  provider = aws.prod
}


resource "aws_ram_sharing_with_organization" "example" {}


resource "aws_ram_resource_share" "example" {
  name                      = "example"
  allow_external_principals = true

  tags = {
    Environment = "Shared"
    Name        = "Example RAM"
  }
}


resource "aws_ram_resource_association" "db_subnets" {
  for_each           = local.db_subnets
  resource_share_arn = aws_ram_resource_share.example.arn
  resource_arn       = aws_subnet.db[each.key].arn
}


resource "aws_ram_resource_association" "app_subnets" {
  for_each           = local.app_subnets
  resource_share_arn = aws_ram_resource_share.example.arn
  resource_arn       = aws_subnet.app[each.key].arn
}


resource "aws_ram_resource_association" "web_subnets" {
  for_each           = local.web_subnets
  resource_share_arn = aws_ram_resource_share.example.arn
  resource_arn       = aws_subnet.web[each.key].arn
}


resource "aws_ram_principal_association" "dev" {
  principal          = data.aws_caller_identity.dev.account_id
  resource_share_arn = aws_ram_resource_share.example.arn
}


resource "aws_ram_principal_association" "prod" {
  principal          = data.aws_caller_identity.prod.account_id
  resource_share_arn = aws_ram_resource_share.example.arn
}


resource "aws_ram_resource_association" "sg" {
  resource_share_arn = aws_ram_resource_share.example.arn
  resource_arn       = aws_security_group.shared.arn
}