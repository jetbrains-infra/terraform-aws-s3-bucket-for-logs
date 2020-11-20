resource "aws_s3_bucket" "logs" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
  tags          = local.tags
}

data "aws_iam_policy_document" "logs_bucket_policy" {
  dynamic "statement" {
    for_each = local.statements

    content {
      sid       = statement.value.description
      actions   = statement.value.actions
      resources = statement.value.resources

      principals {
        type        = "AWS"
        identifiers = statement.value.identifiers
      }
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.bucket
  policy = data.aws_iam_policy_document.logs_bucket_policy.json
}
