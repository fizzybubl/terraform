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

  access_point = {
    path        = "/mnt/efs"
    gid         = "1001"
    uid         = "1001"
    owner_gid   = "1001"
    owner_uid   = "1001"
    permissions = "0777"
    tags        = { "Name" = "Lambda Access Point" }
  }
}