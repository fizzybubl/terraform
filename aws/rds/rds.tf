module "rds" {
  source                 = "./modules/rds"
  username               = "admin"
  password               = "admin1234"
  subnet_ids             = [for az in local.az_ids : module.cloud_db[az].subnet_id]
  db_name                = "test"
  vpc_security_group_ids = [module.rds_sg.sg_id]
}