# R53 ZONES -> IMPORT THE FRA ASSOCIATED ZONE
import {
  id = "Z062945462QZHUMITHWD"
  to = module.fra.aws_route53_zone.this[0]
}


# R53 Records

import {
  id = "Z062945462QZHUMITHWD_internal.example.org_A_eu-central-1"
  to = module.fra.aws_route53_record.this["fra"]
}

import {
  id = "Z062945462QZHUMITHWD_internal.example.org_A_eu-west-1"
  to = module.fra.aws_route53_record.this["dub"]
}
