data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lp_reform_sfn_kms" {
  statement {
    sid    = "AllowStepFunctionsAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [aws_kms_key.lp_reform_sfn_kms.arn]

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:states:arn"
      values   = ["arn:aws:states:${var.aws_region}:${local.aws_account_id}:stateMachine:${local.resource_prefix}-state-machine"]
    }
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [aws_kms_key.lp_reform_sfn_kms.arn]

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["arn:aws:s3:::${local.resource_prefix}-state-machine"]
    }
  }

  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [aws_kms_key.lp_reform_sfn_kms.arn]

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.aws_region}:${local.aws_account_id}:log-group:${local.resource_prefix}-log-group"]
    }
  }
}

data "aws_iam_policy_document" "lp_reform_sfn_assume_role" {
  statement {
    sid    = "StepFunctionAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lp_reform_sfn_policy" {
  statement {
    sid    = "AllowStepFunctionCloudwatchUse"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:${var.aws_region}:${local.aws_account_id}:log-group:${local.resource_prefix}-log-group"]
  }

  statement {
    sid    = "AllowStepFunctionS3Use"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["arn:aws:s3:::${local.resource_prefix}-state-machine/*"]
  }

  statement {
    sid    = "AllowStepFunctionKMSUse"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [aws_kms_key.lp_reform_sfn_kms.arn]
  }
}

data "aws_iam_policy_document" "lp_reform_sfn_logs" {
  statement {
    sid    = "EnableStepFunctionAccessToCloudwatchLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:${var.aws_region}:${local.aws_account_id}:log-group:${local.resource_prefix}-log-group:*"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      values   = ["arn:aws:states:${var.aws_region}:${local.aws_account_id}:stateMachine:${local.resource_prefix}-state-machine"]
      variable = "aws:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "lp_reform_sfn_s3" {
  statement {
    sid    = "AllowStepFunctionObjectAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = ["arn:aws:s3:::${aws_s3_bucket.chds-lp6-renew.id}/*"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:states:${var.aws_region}:${local.aws_account_id}:stateMachine:${local.resource_prefix}-state-machine"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.chds-lp6-renew.id}",
      "arn:aws:s3:::${aws_s3_bucket.chds-lp6-renew.id}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
