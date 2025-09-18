locals {
  definition = jsondecode(file(var.definition_json_file))
}
