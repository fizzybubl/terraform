module "route53" {
    source = "../route53"
    
    zone_name = "mtlsexample.online"
    record_data = {
      type = "alias"
    }

    providers = {
      aws = aws
    }
}