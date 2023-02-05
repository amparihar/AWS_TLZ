module "cmk" {
    source = "./modules/kms"
    providers = {
        aws         = aws
        aws.eufr    = aws.eufr
        aws.usnv    = aws.usnv
        aws.apsi    = aws.apsi
    }
    multi_region    = var.multi_region
}