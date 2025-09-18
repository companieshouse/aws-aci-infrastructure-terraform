variable "aws_region" {
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "deletion_window_in_days" {
  default     = 10
  description = "Duration in days after which the kms key is deleted after destruction of the resource"
  type        = number
}

variable "enable_key_rotation" {
  default     = false
  description = "Specifies whether kms key rotation is enabled"
  type        = bool
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "log_retention_in_days" {
  type        = number
  description = "The default log retention period in days to be used for CloudWatch log groups."
  default     = 7
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  type        = string
}
