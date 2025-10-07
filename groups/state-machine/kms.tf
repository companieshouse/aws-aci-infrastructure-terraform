resource "aws_kms_key" "lp_reform_sfn_kms" {
  description             = "KMS key for ${local.resource_prefix}-state-machine, S3 & CloudWatch Logs"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled              = true
  enable_key_rotation     = var.enable_key_rotation

  tags = merge(
    local.default_tags,
    {
      Alias = "alias/${local.resource_prefix}-state-machine"
    }
  )
}

resource "aws_kms_alias" "sfn_kms_alias" {
  name          = "alias/${local.resource_prefix}-state-machine"
  target_key_id = aws_kms_key.lp_reform_sfn_kms.key_id
}

resource "aws_kms_key_policy" "lp_reform_sfn_kms" {
  key_id = aws_kms_key.lp_reform_sfn_kms.id
  policy = data.aws_iam_policy_document.lp_reform_sfn_kms.json
}
