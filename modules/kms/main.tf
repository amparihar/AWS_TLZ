locals {
    trusting_accounts = yamldecode(file("${path.module}/conf/trusting_accounts.yaml"))["accounts"]
    principals = (local.trusting_accounts == null) ? [] : [ for v in local.trusting_accounts : tostring(v) ]
}

locals {
  trusting_principals = (length(local.principals) == 0) ? "" : jsonencode([for v in local.principals: "arn:aws:iam::${v}:root"])
  key_policy_template_values = {
                            ACCOUNT_ID    = data.aws_caller_identity.current.account_id
                            VEEAM_ACCOUNT = "1234567890" 
                            TRUSTING_PRINCIPALS = local.trusting_principals
                          }
  key_policy_document   = templatefile("${path.module}/templates/kms_key_policy.tpl", local.key_policy_template_values)
}

resource "aws_kms_key" "this" {
  description             = var.cmk_description 
  deletion_window_in_days = 7
  policy                  = local.key_policy_document
  multi_region            = var.multi_region
  # tags                    = merge(var.tags, {"type" : "Primary Customer Master Key"})
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.cmk_alias_name}"
  target_key_id = aws_kms_key.this.key_id
}

# Replica Key for EU, Frankfurt
resource "aws_kms_replica_key" "eufr" {
  provider                = aws.eufr
  count                   = data.aws_region.current.name == data.aws_region.eufr.name ? 0 : var.multi_region ? 1 : 0
  description             = "Replica Key for EU, Frankfurt"
  deletion_window_in_days = 7
  policy                  = local.key_policy_document
  primary_key_arn         = aws_kms_key.this.arn
  # tags                    = merge(var.tags, {"type" : "Replica Key for EU, Frankfurt"})
}

resource "aws_kms_alias" "eufr" {
  provider      = aws.eufr
  count         = data.aws_region.current.name == data.aws_region.eufr.name ? 0 : var.multi_region ? 1 : 0
  name          = "alias/${var.cmk_alias_name}_eufr"
  target_key_id = aws_kms_replica_key.eufr[0].key_id
}

# Replica Key for US, North Virginia
resource "aws_kms_replica_key" "usnv" {
  provider                = aws.usnv
  count                   = data.aws_region.current.name == data.aws_region.usnv.name ? 0 : var.multi_region ? 1 : 0
  description             = "Replica Key for US, North Virginia"
  deletion_window_in_days = 7
  policy                  = local.key_policy_document
  primary_key_arn         = aws_kms_key.this.arn
  # tags                    = merge(var.tags, {"type" : "Replica Key for US, North Virginia"})
}

resource "aws_kms_alias" "usnv" {
  provider      = aws.usnv
  count         = data.aws_region.current.name == data.aws_region.usnv.name ? 0 : var.multi_region ? 1 : 0
  name          = "alias/${var.cmk_alias_name}_usnv"
  target_key_id = aws_kms_replica_key.usnv[0].key_id
}

# Replica Key for Asia, Singapore
resource "aws_kms_replica_key" "apsi" {
  provider                = aws.apsi
  count                   = data.aws_region.current.name == data.aws_region.apsi.name ? 0 : var.multi_region ? 1 : 0
  description             = "Replica Key for Asia, Singapore"
  deletion_window_in_days = 7
  policy                  = local.key_policy_document
  primary_key_arn         = aws_kms_key.this.arn
  # tags                    = merge(var.tags, {"type" : "Replica Key for Asia, Singapore"})
}

resource "aws_kms_alias" "apsi" {
  provider      = aws.apsi
  count         = data.aws_region.current.name == data.aws_region.apsi.name ? 0 : var.multi_region ? 1 : 0
  name          = "alias/${var.cmk_alias_name}_apsi"
  target_key_id = aws_kms_replica_key.apsi[0].key_id
}


