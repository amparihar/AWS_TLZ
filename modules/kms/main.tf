
locals {
    trusting_accounts = yamldecode(file("${path.module}/conf/trusting_accounts.yaml"))["accounts"]
    principals = (local.trusting_accounts == null) ? [] : [ for v in local.trusting_accounts : tostring(v) ]
}

locals {
  trusting_principals = (length(local.principals) == 0) ? "" : jsonencode([for v in local.principals: "arn:aws:iam::${v}:root"])
  key_policy_template_values = {
                            ACCOUNT_ID    = data.aws_caller_identity.current.account_id
                            VEEAM_ACCOUNT = "785548451685" 
                            TRUSTING_PRINCIPALS = local.trusting_principals
                          }
}

resource "aws_kms_key" "this" {
  description             = "Centralized Key"
  deletion_window_in_days = 7
  policy                  = templatefile("${path.module}/templates/kms_key_policy.tpl", local.key_policy_template_values)
  multi_region            = false

  //tags = local.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/us_e2_key"
  target_key_id = aws_kms_key.this.key_id
}



