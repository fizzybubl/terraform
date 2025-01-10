resource "aws_ec2_transit_gateway" "example" {
  description = "example"
}


resource "aws_ec2_transit_gateway_route_table" "prod" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  tags = {
    "Name" = "PROD Route Table"
  }
}



resource "aws_ec2_transit_gateway_route_table" "stg" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  tags = {
    "Name" = "STG Route Table"
  }
}


resource "aws_ec2_transit_gateway_route_table" "dmz" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  tags = {
    "Name" = "DMZ Route Table"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  vpc_id                                          = module.prod.vpc.id
  subnet_ids                                      = module.prod.private_subnets[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "pre_prod" {
  vpc_id                                          = module.pre_prod.vpc.id
  subnet_ids                                      = module.pre_prod.private_subnets[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "stg" {
  vpc_id                                          = module.stg.vpc.id
  subnet_ids                                      = module.stg.private_subnets[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "dev" {
  vpc_id                                          = module.dev.vpc.id
  subnet_ids                                      = module.dev.private_subnets[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "dmz" {
  vpc_id                                          = module.dmz.vpc.id
  subnet_ids                                      = module.dmz.public_subnets[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_route_table_association" "prod" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.prod.id
}


resource "aws_ec2_transit_gateway_route_table_association" "pre_prod" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pre_prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.prod.id
}


resource "aws_ec2_transit_gateway_route_table_association" "stg" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.stg.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.stg.id
}


resource "aws_ec2_transit_gateway_route_table_association" "dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.stg.id
}


resource "aws_ec2_transit_gateway_route_table_association" "dmz" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dmz.id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "prod" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.prod.id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "pre_prod" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pre_prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.prod.id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "stg" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.stg.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.stg.id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.stg.id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "dmz" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dmz.id
}