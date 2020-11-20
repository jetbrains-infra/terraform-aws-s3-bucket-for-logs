variable "cdn_logs_path" {
  description = "Prefix for CloudFront logs."
  type        = string
  default     = "cdn/"
}
variable "alb_logs_path" {
  description = "Prefix for ALB logs."
  type        = string
  default     = "alb"
}
variable "s3_logs_path" {
  description = "Prefix for S3 access logs."
  type        = string
  default     = "s3/"
}
variable "bucket" {
  description = "Bucket name."
  type        = string
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
variable "tags" {
  description = "Tags."
  type        = map(string)
}
data "aws_elb_service_account" "current" {}

locals {
  aws_services = [
    {
      description = "Allow LB to write logs"
      actions     = ["s3:PutObject"]
      resources   = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.alb_logs_path}*"]
      identifiers = [data.aws_elb_service_account.current.arn]
    },
    {
      description = "Permit access log delivery for Log Delivery service"
      actions     = ["s3:PutObject"]
      resources   = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.s3_logs_path}*"]
      identifiers = ["arn:aws:iam::858827067514:root"]
    },
    {
      description = "Permit access log delivery for CloudFront service"
      actions     = ["s3:PutObject"]
      resources   = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.cdn_logs_path}*"]
      identifiers = ["arn:aws:iam::162777425019:root"]
    }
  ]
  readers = [
    {
      description = "Permit access to logs for specific AWS accounts"
      actions     = ["s3:Get*"]
      resources   = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/*"]
      identifiers = formatlist("arn:aws:iam::%s:root", var.readers)
    }
  ]
  statements = var.readers != [] ? concat(local.aws_services, local.readers) : local.aws_services
  tags = merge({
    Module       = "S3 Bucket for Logs"
    ModuleSource = "https://github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs/"
  }, var.tags)
}