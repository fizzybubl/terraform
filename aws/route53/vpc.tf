data "aws_vpc" "ger" {
  default = true
}

data "aws_vpc" "ire" {
  provider = aws.ire
  default  = true
}


data "aws_vpc" "dev" {
  provider = aws.dev
  default  = true
}