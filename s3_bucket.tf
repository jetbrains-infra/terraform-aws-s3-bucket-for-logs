resource "aws_s3_bucket" "logs" {
  bucket        = local.bucket
  force_destroy = local.force_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = local.server_side_encryption_configuration_bucket_key_sse_algorithm
        kms_master_key_id = local.server_side_encryption_configuration_bucket_key_kms_master_key_id
      }
      bucket_key_enabled = local.server_side_encryption_configuration_bucket_key_enabled
    }
  }
  tags = local.tags
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
