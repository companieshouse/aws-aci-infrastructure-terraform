
locals {

  container_properties_json = local.job_definition_type == "CONTAINER" ? jsonencode(local.decoded_properties.containerProperties) : null
  node_properties_json      = local.job_definition_type == "MULTINODE" ? jsonencode(local.decoded_properties.nodeProperties) : null
  job_definition_type       = contains(["MULTINODE_EC2"], local.scenario_key) ? "MULTINODE" : "CONTAINER"
  scenario_key              = "${upper(var.type)}_${upper(tolist(var.platform_capabilities)[0])}"
  decoded_properties        = jsondecode(local.rendered_properties_json)
  rendered_properties_json  = templatefile("${path.module}/templates/all_properties.json.tpl", local.job_properties_map)

  job_properties_map = {
    containerProperties = local.merged_container_properties
    nodeProperties      = var.template_vars.nodeProperties
    eksProperties       = var.template_vars.eksProperties
  }

  retry_strategy = {
    attempts       = var.retry_attempts
    evaluateOnExit = length(local.filtered_evaluate_on_exit) > 0 ? local.filtered_evaluate_on_exit : null
  }

  filtered_evaluate_on_exit = [
    for rule in var.evaluate_on_exit : rule
    if(
      length(trimspace(rule.on_reason)) > 0 &&
      length(rule.on_reason) <= 512 &&
      length(trimspace(rule.on_status_reason)) > 0 &&
      length(rule.on_status_reason) <= 512
    )
  ]

  merged_container_properties = merge(
    var.template_vars.containerProperties,
    {
      retryStrategy = local.retry_strategy
    }
  )
}
