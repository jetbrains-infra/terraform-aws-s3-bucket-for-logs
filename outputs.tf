output "alb_logs_bucket" {
  value = aws_s3_bucket.logs.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.logs.arn
}

output "s3_logs_bucket" {
  value = aws_s3_bucket.logs.id
}

output "cdn_logs_bucket" {
  value = aws_s3_bucket.logs.bucket_domain_name
}

output "s3_logs_path" {
  value = var.s3_logs_path
}

output "alb_logs_path" {
  value = var.alb_logs_path
}

output "cdn_logs_path" {
  value = var.cdn_logs_path
}
