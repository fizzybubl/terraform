resource "aws_organizations_organizational_unit" "dev" {
  name      = "DEV"
  parent_id = data.aws_organizations_organization.root_org.roots[0].id

  tags = {
    "Created by" = "AcousticBear"
  }
  tags_all = {
    "Created by" = "AcousticBear"
  }
}


resource "aws_organizations_organizational_unit" "prod" {
  name      = "PROD"
  parent_id = data.aws_organizations_organization.root_org.roots[0].id

  tags = {
    "Created by" = "AcousticBear"
  }
  tags_all = {
    "Created by" = "AcousticBear"
  }
}
