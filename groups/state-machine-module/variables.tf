variable "name" {
  type        = string
  description = "Name of the Step Functions state machine"
}

variable "role_arn" {
  type        = string
  description = "IAM role ARN for the state machine"
}

variable "definition_json_file" {
  type        = string
  description = "Path to the full state machine definition JSON file"
}

variable "tags" {
  type    = map(string)
  default = {}
}
