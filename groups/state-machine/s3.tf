# S3 Bucket with KMS Encryption
resource "aws_s3_bucket" "chds-lp6-renew" {
  bucket = "${local.resource_prefix}-chds-lp6-renew"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp6-renew"
    }
  )
}

resource "aws_s3_bucket_policy" "state_machine_bucket_policy" {
  bucket = aws_s3_bucket.chds-lp6-renew.id
  policy = data.aws_iam_policy_document.lp_reform_sfn_s3.json
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.chds-lp6-renew.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lp_reform_sfn_sse" {
  bucket = aws_s3_bucket.chds-lp6-renew.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.chds-lp6-renew.id

  versioning_configuration {
    status = "Disabled"
  }
}

# module "s3_access_logging_ssm" {
#   source = "git@github.com:companieshouse/terraform-modules//aws/s3_access_logging?ref=tags/1.0.338"

#   aws_account           = local.aws_account_id
#   aws_region            = var.aws_region
#   source_s3_bucket_name = aws_s3_bucket.chds-lp6-renew.id
# }
