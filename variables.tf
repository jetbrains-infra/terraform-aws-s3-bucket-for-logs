variable "cdn_logs_path" {
  description = "Prefix for CloudFront logs"
  default     = "cdn/"
}

variable "alb_logs_path" {
  description = "Prefix for ALB logs"
  default     = "alb/"
}

variable "s3_logs_path" {
  description = "Prefix for S3 access logs"
  default     = "s3/"
}

variable "bucket" {
  description = "Bucket name"
}
