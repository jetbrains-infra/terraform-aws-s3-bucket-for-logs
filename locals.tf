locals {
  bucket                                                            = var.bucket
  s3_logs_prefix                                                    = var.s3_logs_path
  alb_logs_prefix                                                   = var.alb_logs_path
  account_id                                                        = data.aws_caller_identity.current.account_id
  elb_service_account_arn                                           = data.aws_elb_service_account.current.arn
  readers                                                           = var.readers
  force_destroy                                                     = var.force_destroy
  server_side_encryption_configuration_bucket_key_enabled           = var.server_side_encryption_configuration_bucket_key_enabled
  server_side_encryption_configuration_bucket_key_sse_algorithm     = var.server_side_encryption_configuration_bucket_key_sse_algorithm
  server_side_encryption_configuration_bucket_key_kms_master_key_id = var.server_side_encryption_configuration_bucket_key_kms_master_key_id
  tags = {
    Module       = "S3 Bucket for Logs"
    ModuleSource = "https://github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs/"
  }
}