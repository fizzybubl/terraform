resource "aws_security_group" "fra" {
  name        = "fra-sg"
  description = "Allow traffic only within the VPC"
  vpc_id      = module.vpc_fra.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc_fra.cidr_block]
  }

  #   egress {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = [module.vpc_fra.cidr_block]
  #   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Fra SG"
  }
}