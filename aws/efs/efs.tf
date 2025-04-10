module "efs" {
  source = "./efs"
  name   = "EFS_Test"
  subnet_ids = {
    "subnet_1" : {
      subnet_id       = module.private_subnet_1.subnet_id
      security_groups = [aws_security_group.aws_ec2.id]
    },
    "subnet_2" : {
      subnet_id       = module.private_subnet_2.subnet_id
      security_groups = [aws_security_group.aws_ec2.id]
    }
  }
}