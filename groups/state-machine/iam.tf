resource "aws_iam_role" "lp_reform_sfn" {
  name               = "${local.resource_prefix}-state-machine-role"
  assume_role_policy = data.aws_iam_policy_document.lp_reform_sfn_assume_role.json
}

resource "aws_iam_role_policy" "lp_reform_sfn_policy" {
  name   = "${local.resource_prefix}-state-machine-policy"
  role   = aws_iam_role.lp_reform_sfn.id
  policy = data.aws_iam_policy_document.lp_reform_sfn_policy.json
}
