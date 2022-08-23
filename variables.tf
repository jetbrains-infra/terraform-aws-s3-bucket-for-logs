variable "cdn_logs_path" {
  description = "Prefix for CloudFront logs."
  type        = string
  default     = "cdn"

  validation {
    condition     = substr(var.cdn_logs_path, 0, 1) != "/" && substr(var.cdn_logs_path, -1, 1) != "/" && length(var.cdn_logs_path) > 0
    error_message = "Parameter `cdn_logs_path` cannot start and end with \"/\", as well as cannot be empty."
  }
}
variable "alb_logs_path" {
  description = "Prefix for ALB logs."
  type        = string
  default     = "alb"

  validation {
    condition     = substr(var.alb_logs_path, 0, 1) != "/" && substr(var.alb_logs_path, -1, 1) != "/" && length(var.alb_logs_path) > 0
    error_message = "Parameter `alb_logs_path` cannot start and end with \"/\", as well as cannot be empty."
  }
}
variable "s3_logs_path" {
  description = "Prefix for S3 access logs."
  type        = string
  default     = "s3"

  validation {
    condition     = substr(var.s3_logs_path, 0, 1) != "/" && substr(var.s3_logs_path, -1, 1) != "/" && length(var.s3_logs_path) > 0
    error_message = "Parameter `s3_logs_path` cannot start and end with \"/\", as well as cannot be empty."
  }
}
variable "bucket" {
  description = "Bucket name."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket))
    error_message = "Invalid bucket name, please check https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html for more details."
  }
}
variable "force_destroy" {
  description = "Allow remove the bucket with its content."
  type        = bool
  default     = false
}
variable "readers" {
  description = "List of AWS accounts who can read the logs."
  type        = list(string)
  default     = []
}
data "aws_elb_service_account" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  bucket                  = var.bucket
  s3_logs_prefix          = var.s3_logs_path
  alb_logs_prefix         = var.alb_logs_path
  account_id              = data.aws_caller_identity.current.account_id
  elb_service_account_arn = data.aws_elb_service_account.current.arn
  readers                 = var.readers
  force_destroy           = var.force_destroy
  canonical_ids = {
    "aws-cn" = "a52cb28745c0c06e84ec548334e44bfa7fc2a85c54af20cd59e4969344b7af56", // https://docs.amazonaws.cn/en_us/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    "aws"    = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"  // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }

  tags = {
    Module       = "S3 Bucket for Logs"
    ModuleSource = "https://github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs/"
  }
}
