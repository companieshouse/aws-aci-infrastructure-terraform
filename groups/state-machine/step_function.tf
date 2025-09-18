module "state_machine" {
  source               = "../state-machine-module"
  name                 = "MyStateMachine-r4siyd8tf"
  role_arn             = aws_iam_role.lp_reform_sfn.arn
  definition_json_file = "${path.root}/templates/state_machine_definition.json"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.resource_prefix}-MyStateMachine-r4siyd8tf"
    }
  )
}
