
data "aws_caller_identity" "current" {}

data "vault_generic_secret" "security_kms" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "tenable" {
  path = "infrastructure/applications/tenable"
}