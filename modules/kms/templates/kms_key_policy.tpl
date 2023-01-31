{
    "Version": "2012-10-17",
    "Id": "keypolicy",
    "Statement": [
        {
          "Sid" : "Enable IAM User Permissions",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${ACCOUNT_ID}:root"
          },
          "Action" : "kms:*",
          "Resource" : "*"
        },
        %{ if length(TRUSTING_PRINCIPALS) > 0 ~}
        {
            "Sid": "Allow Cross Account Access to Production Accounts",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${TRUSTING_PRINCIPALS}
             },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow Cross Account Access to Production Accounts for attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${TRUSTING_PRINCIPALS}
             },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*"
        },
        %{endif ~}
        {
            "Sid": "Allow use of the key for Veeam Account Role",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${VEEAM_ACCOUNT}:role/veeam-backup-and-restore"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources Veeam Account Role",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${VEEAM_ACCOUNT}:role/veeam-backup-and-restore"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        },
        {
            "Sid": "Allow use of the key for Veeam Account Management Service Role",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${VEEAM_ACCOUNT}:role/veeam-service-role"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources Veeam Account Management Service Role",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${VEEAM_ACCOUNT}:role/veeam-service-role"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        },
        {
            "Sid": "Allow attachment of persistent resources Veeam Account root - permissions deligation in Veeam Account",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${VEEAM_ACCOUNT}:root"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}