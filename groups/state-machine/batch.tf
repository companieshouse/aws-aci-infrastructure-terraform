module chds-lp-reform-manifest-generator-definition {
  source = "../batch-job-module"

  name                  = "chds-lp-reform-manifest-generator-definition"
  type                  = "CONTAINER"
  platform_capabilities = ["FARGATE"]
  parameters            = {}

  template_vars = jsondecode(file("${path.root}/templates/chds-lp-reform-manifest-generator-definition.json"))

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp-reform-manifest-generator-definition"
    }
  )
}

module chds-lp-reform-pdf-definition {
  source = "../batch-job-module"

  name                  = "chds-lp-reform-pdf-definition"
  type                  = "CONTAINER"
  platform_capabilities = ["FARGATE"]
  parameters            = {}
  retry_attempts        = 1
  evaluate_on_exit      = []
  
  template_vars = jsondecode(file("${path.root}/templates/chds-lp-reform-pdf-definition.json"))

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp-reform-pdf-definition"
    }
  )
}

module chds-lp-reform-ocr-definition {
  source = "../batch-job-module"

  name                  = "chds-lp-reform-ocr-definition"
  type                  = "CONTAINER"
  platform_capabilities = ["FARGATE"]
  parameters            = {}
  retry_attempts        = 1
  evaluate_on_exit      = []

  template_vars = jsondecode(file("${path.root}/templates/chds-lp-reform-ocr-definition.json"))

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp-reform-ocr-definition"
    }
  )
}

resource "aws_batch_compute_environment" "chds-lp-reform" {
  compute_environment_name = "chds-lp-reform"
  type                     = "MANAGED"
  state                    = "ENABLED"
  service_role             = "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch"

  compute_resources {
    type               = "FARGATE"
    max_vcpus          = 32
    subnets            = ["subnet-ccfc83a5", "subnet-b9bd74f5", "subnet-b95fe4c3"]
    security_group_ids = ["sg-c8bc7fa6"]

    tags = merge(
      local.default_tags,
      {
        Name = "${var.environment}-chds-lp-reform-compute_env"
      }
    )
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp-reform-compute_env"
    }
  )
}

resource "aws_batch_job_queue" "chds_lp_reform_queue" {
  name     = "chds-lp-reform-queue"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.chds-lp-reform.arn
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-chds-lp-reform-queue"
    }
  )
}
