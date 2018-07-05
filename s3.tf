resource "aws_s3_bucket" "logs" {
  bucket = "${var.bucket}"
}

data "aws_iam_policy_document" "logs_bucket_policy" {

  statement {
    sid       = "Allow LB to write logs"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.alb_logs_path}*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::156460612806:root"]
    }
  }

  statement {
    sid       = "Permit access log delivery by AWS ID for Log Delivery service"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.s3_logs_path}*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::858827067514:root"]
    }
  }

  statement {
    sid       = "Permit access log delivery by AWS ID for CloudFront service"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.logs.bucket}/${var.cdn_logs_path}*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::162777425019:root"]
    }
  }

}

resource "aws_s3_bucket_policy" "logs" {
  bucket = "${aws_s3_bucket.logs.bucket}"
  policy = "${data.aws_iam_policy_document.logs_bucket_policy.json}"
}
