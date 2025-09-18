locals {
  aws_account_id  = data.aws_caller_identity.current.account_id
  resource_prefix = "${var.environment}-${var.service}"

  default_tags = {
    Environment = var.environment
    Service     = var.service
  }
}
