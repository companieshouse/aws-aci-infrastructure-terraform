resource "aws_sfn_state_machine" "state_machine" {
  name       = var.name
  role_arn   = var.role_arn
  type       = "STANDARD"
  definition = jsonencode(local.definition)
  tags       = var.tags
}
