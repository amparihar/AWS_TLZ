provider "aws" {
  region = var.aws_regions[var.aws_region]
}


# Region specific Provider

provider "aws" {
  alias  = "eufr" # EU, Frankfurt
  region = "eu-central-1"

  # default_tags {
  #   tags = var.tags
  # }
}

provider "aws" {
  alias  = "usnv" # US, North Virginia
  region = "us-east-1"

  # default_tags {
  #   tags = var.tags
  # }
}

provider "aws" {
  alias  = "apsi" # Asia Pacific, Singapore
  region = "ap-southeast-1"

  # default_tags {
  #   tags = var.tags
  # }
}
