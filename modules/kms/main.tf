
locals {
    trusting_accounts = yamldecode(file("${path.module}/conf/trusting_principals.yaml"))["accounts"]
    principles = [ for v in local.trusting_accounts : tostring(v) ]
    trusting_accounts_parsed = join(",",[ for v in local.trusting_accounts : "\"${v}\"" ])
    trusting_accounts_parsed2 = jsonencode([for v in local.principles: "arn:aws:iam::${v}:root"])
}

resource "aws_kms_key" "this" {
  description             = "Centralized Key"
  deletion_window_in_days = 7
  policy = templatefile("${path.module}/templates/kms_key_policy.tpl", {
    ACCOUNT_ID    = data.aws_caller_identity.current.account_id
    VEEAM_ACCOUNT = "785548451685" 
    //TRUSTING_ACCOUNTS =  [ for v in local.trusting_accounts : "\"${v}\"" ]
    TRUSTING_ACCOUNTS = local.trusting_accounts_parsed2
  })
  multi_region = false

  //tags = local.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/us_e2_key"
  target_key_id = aws_kms_key.this.key_id
}

output "test" {
  value = local.principles// substr(local.trusting_accounts_parsed,0, length(local.trusting_accounts_parsed))
}


