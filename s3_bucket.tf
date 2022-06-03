resource "aws_s3_bucket" "logs" {
  bucket        = local.bucket
  force_destroy = local.force_destroy
  tags          = local.tags
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
