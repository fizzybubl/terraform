data "aws_ami" "ami" {
  filter {
    name   = "image-id"
    values = ["ami-0559679b06ebd7e58"]
  }
}

module "ec2" {
  source = "../ec2/modules/ec2"
  instance_type = "t2.micro"
  ami_id = data.aws_ami.ami.id
  subnet_ids = []
  security_group_ids = []

  block_device_mappings = [{
    device_name = "/dev/xvda"
    ebs = {
      volume_size = 8
    }
  }]
}