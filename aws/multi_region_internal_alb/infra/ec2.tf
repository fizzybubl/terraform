data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}


resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.ami.id # Example Amazon Linux 2 AMI (eu-west-1). Update as needed.
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.private_fra["euc1-az1"].id
  vpc_security_group_ids      = [module.ssm_sg.sg_id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2.name

  tags = {
    Name = "private-ec2"
  }
}


resource "aws_iam_role" "ec2" {
  name = "access-to-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  tags = {
    "Name" : "Access To SSM"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "ec2_test"
  role        = aws_iam_role.ec2.name
  path        = "/"
}