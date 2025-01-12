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
  vpc_id                                          = aws_vpc.prod.id
  subnet_ids                                      = [for s in aws_subnet.private_subnets_tgw_prod : s.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "pre_prod" {
  vpc_id                                          = aws_vpc.pre_prod.id
  subnet_ids                                      = [for s in aws_subnet.private_subnets_tgw_pre_prod : s.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "stg" {
  vpc_id                                          = aws_vpc.stg.id
  subnet_ids                                      = [for s in aws_subnet.private_subnets_tgw_stg : s.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "dev" {
  vpc_id                                          = aws_vpc.dev.id
  subnet_ids                                      = [for s in aws_subnet.private_subnets_tgw_dev : s.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "dmz" {
  vpc_id                                          = aws_vpc.dmz.id
  subnet_ids                                      = [for s in aws_subnet.private_subnets_tgw_dmz : s.id]
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