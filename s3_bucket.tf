resource "aws_s3_bucket" "logs" {
  bucket        = local.bucket
  force_destroy = local.force_destroy
  tags          = local.tags
  policy        = data.aws_iam_policy_document.bucket_policy.json
}
