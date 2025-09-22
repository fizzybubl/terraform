data "aws_vpc" "fra" {
  provider = aws.fra
  tags = {
    Name = "Fra"
  }
}


data "aws_vpc" "dub" {
  provider = aws.dub
  tags = {
    Name = "Dub"
  }
}