data "aws_lb" "dub" {
  provider = aws.dub
  name     = "dub-internal-lb"
}


data "aws_lb" "fra" {
  provider = aws.fra
  name     = "fra-internal-lb"
}