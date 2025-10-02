module "fra" {
  source    = "../../route53/hosted_zone"
  zone_name = "example.org"
  vpc_ids = [
    {
      vpc_id = data.aws_vpc.fra.id
      region = "eu-central-1"
    },
    {
      vpc_id = data.aws_vpc.dub.id
      region = "eu-west-1"
    }
  ]


  record_data = {
    fra = {
      name = "internal.example.org"
      type = "A"
      alias = {
        zone_id                = data.aws_lb.fra.zone_id
        name                   = data.aws_lb.fra.dns_name
        evaluate_target_health = true
      }

      latency_routing_policy = {
        region = "eu-central-1"
      }
      set_identifier = "eu-central-1"
    },
    dub = {
      name = "internal.example.org"
      type = "A"
      alias = {
        zone_id                = data.aws_lb.dub.zone_id
        name                   = data.aws_lb.dub.dns_name
        evaluate_target_health = true
      }
      latency_routing_policy = {
        region = "eu-west-1"
      }
      set_identifier = "eu-west-1"
    }
  }

  depends_on = [data.aws_lb.fra, data.aws_lb.dub]
}






# module "dub" {
#   providers = {
#     aws = aws.dub
#   }
#   source    = "../../route53/hosted_zone"
#   zone_name = "example.org"
#   vpc_ids = [
#     {
#       vpc_id = data.aws_vpc.dub.id
#       region = "eu-west-1"
#     }
#   ]

#   record_data = {
#     fra = {
#       name = "internal.example.org"
#       type = "A"
#       alias = {
#         zone_id                = data.aws_lb.fra.zone_id
#         name                   = data.aws_lb.fra.dns_name
#         evaluate_target_health = true
#       }

#       latency_routing_policy = {
#         region = "eu-central-1"
#       }
#       set_identifier = "eu-central-1"
#     },
#     dub = {
#       name = "internal.example.org"
#       type = "A"
#       alias = {
#         zone_id                = data.aws_lb.dub.zone_id
#         name                   = data.aws_lb.dub.dns_name
#         evaluate_target_health = true
#       }
#       latency_routing_policy = {
#         region = "eu-west-1"
#       }
#       set_identifier = "eu-west-1"
#     }
#   }

#   depends_on = [data.aws_lb.fra, data.aws_lb.dub]
# }
