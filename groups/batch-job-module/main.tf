resource "aws_batch_job_definition" "batch" {
  name                       = var.name
  type                       = var.type
  platform_capabilities      = var.platform_capabilities
  container_properties       = local.container_properties_json
  node_properties            = local.node_properties_json
  deregister_on_new_revision = var.deregister_on_new_revision
  parameters                 = var.parameters
  propagate_tags             = var.propagate_tags
  scheduling_priority        = var.scheduling_priority

  timeout {
    attempt_duration_seconds = var.timeout_seconds
  }

  tags = var.tags
}
