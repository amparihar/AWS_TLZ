provider "aws" {
  region = var.aws_regions[var.aws_region]
}


module "cmk" {
    source = "./modules/kms"
}

output "test" {
  value = module.cmk.test
}