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
variable "server_side_encryption_configuration_bucket_key_enabled" {
  description = "Specify if to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = bool
  default     = false
}
variable "server_side_encryption_configuration_bucket_key_sse_algorithm" {
  description = "Specify what server-side encryption algorithm to use."
  validation {
    condition     = can(regexall("AES256|aws:kms", var.server_side_encryption_configuration_bucket_key_sse_algorithm))
    error_message = "Supported values are AES256 or aws:kms."
  }
  type    = string
  default = "AES256"
}
variable "server_side_encryption_configuration_bucket_key_kms_master_key_id" {
  description = "Specify the configuration for the server side configuration of the S3 bucket."
  type        = string
  default     = null
}