
module "tenable_audit_role" {
  count = var.enable_audit ? 1 : 0

  source = "git@github.com:companieshouse/terraform-modules//aws/tenable-audit?ref=1.0.353"

  cloudtrail_scanning = {
    kms_key_arn   = local.cloudtrail_key_arn
    s3_bucket_arn = local.cloudtrail_bucket_arn
  }
  enable_data_resource_scanning = false
  enable_ec2_instance_scanning  = false
  enable_ecr_scanning           = false
  enable_monitoring             = true
  tenable_account_id            = local.tenable_account_id
  tenable_external_id           = local.tenable_external_id
}
