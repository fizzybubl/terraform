module "efs" {
  source = "../efs/efs"
  name   = "EFS_Test"
  subnet_ids = {
    "subnet_1" : {
      subnet_id       = module.cloud_app[local.az3].subnet_id
      security_groups = [module.efs_sg.sg_id]
    },
    "subnet_2" : {
      subnet_id       = module.cloud_app[local.az2].subnet_id
      security_groups = [module.efs_sg.sg_id]
    }
  }
}