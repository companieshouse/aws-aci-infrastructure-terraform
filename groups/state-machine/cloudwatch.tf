resource "aws_cloudwatch_log_group" "lp_reform_sfn" {
  kms_key_id        = aws_kms_key.lp_reform_sfn_kms.arn
  name              = "${local.resource_prefix}-log-group"
  retention_in_days = var.log_retention_in_days

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-log-group"
    }
  )
}

resource "aws_cloudwatch_log_resource_policy" "lp_reform_sfn_logs" {
  policy_document = data.aws_iam_policy_document.lp_reform_sfn_logs.json
  policy_name     = "${local.resource_prefix}-logs-policy"
}
