# R53 ZONES -> IMPORT THE FRA ASSOCIATED ZONE
import {
  id = "Z06868462EY7KNUGLVKF9"
  to = module.fra.aws_route53_zone.this[0]
}


# R53 Records

import {
  id = "Z06868462EY7KNUGLVKF9_internal.example.org_A_eu-central-1"
  to = module.fra.aws_route53_record.this["fra"]
}

import {
  id = "Z06868462EY7KNUGLVKF9_internal.example.org_A_eu-west-1"
  to = module.fra.aws_route53_record.this["dub"]
}
