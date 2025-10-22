locals {

  security_kms_secrets = data.vault_generic_secret.security_kms.data
  security_s3_secrets  = data.vault_generic_secret.security_s3.data
  tenable_secrets      = data.vault_generic_secret.tenable.data

  cloudtrail_key_arn    = local.security_kms_secrets["cloudtrail-kms-key-arn"]
  cloudtrail_bucket_arn = local.security_s3_secrets["cloudtrail-bucket-arn"]
  tenable_account_id    = local.tenable_secrets.account_id
  tenable_external_id   = local.tenable_secrets.external_id

}
