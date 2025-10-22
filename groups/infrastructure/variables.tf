variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}
variable "tags" {
  type        = map(string)
  description = "The default tags to add to all resources"
  default = {
    Terraform   = "https://github.com/companieshouse/aws-aci-infrastructure-terraform"
    Environment = "aci"
  }
}

# ------------------------------------------------------------------------------
# Tenable Variables
# ------------------------------------------------------------------------------
variable "enable_audit" {
  type        = bool
  description = "Toggle tenable role provisioning"
  default     = true
}
