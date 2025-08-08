module "zone" {
  source           = "./hosted_zone"
  zone_name        = "example.org"
  zone_description = "private zone test"
  vpc_ids          = [{ vpc_id = data.aws_vpc.ger.id, region = "eu-central-1" }, { vpc_id = data.aws_vpc.ire.id, region = "eu-west-1" }]

  record_data = {
    "frankfurt" : {
      name           = "test"
      type           = "A"
      ttl            = "300"
      records        = ["172.31.1.23"]
      set_identifier = "frankfurt"
      latency_routing_policy = {
        region = "eu-central-1"
      }
    },
    "dublin" : {
      name           = "test"
      type           = "A"
      ttl            = "300"
      records        = ["172.31.2.23"]
      set_identifier = "dublin"
      latency_routing_policy = {
        region = "eu-west-1"
      }
    }
  }
}


module "zone_2" {
  source = "./hosted_zone"
  record_data = {
    "frankfurt" : {
      name           = "mtls"
      zone_id        = module.zone.zone_id
      type           = "A"
      ttl            = "300"
      records        = ["172.31.1.23"]
      set_identifier = "Frankfurt"
      latency_routing_policy = {
        region = "eu-central-1"
      }
    },
    "dublin" : {
      name           = "mtls"
      zone_id        = module.zone.zone_id
      type           = "A"
      ttl            = "300"
      records        = ["172.31.2.23"]
      set_identifier = "Dublin"
      latency_routing_policy = {
        region = "eu-west-1"
      }
    }
  }
}