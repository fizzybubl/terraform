# R53 ZONES -> IMPORT THE FRA ASSOCIATED ZONE
import {
  id = ""
  to = module.fra.aws_route53_zone.this[0]
}


# R53 Records

import {
  id = ""
  to = module.fra.aws_route53_record.this["fra"]
}

import {
  id = "" 
  to = module.fra.aws_route53_record.this["dub"]
}
