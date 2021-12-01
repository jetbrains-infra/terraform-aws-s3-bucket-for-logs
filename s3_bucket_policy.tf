data "aws_iam_policy_document" "s3" {
  statement {
    sid = "S3ServerAccessLogsPolicy"
    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${local.bucket}/${local.s3_logs_prefix}/*"]
  }
}

data "aws_iam_policy_document" "alb" {
  statement {
    principals {
      identifiers = [local.elb_service_account_arn]
      type        = "AWS"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket}/${local.alb_logs_prefix}/AWSLogs/${local.account_id}/*"]
  }

  statement {
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket}/${local.alb_logs_prefix}/AWSLogs/${local.account_id}/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.bucket}"]
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    principals {
      // Canonical ID transforms to this value and there is always drift
      // "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
      // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
      identifiers = ["arn:aws:iam::162777425019:root"]
      type        = "AWS"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket}/${var.cdn_logs_path}/*"]
  }
}

data "aws_iam_policy_document" "external_readers" {
  statement {
    principals {
      identifiers = formatlist("arn:aws:iam::%s:root", local.readers)
      type        = "AWS"
    }
    actions = [
      "s3:Get*"
    ]
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  source_policy_documents = length(local.readers) == 0 ? [
    data.aws_iam_policy_document.s3.json,
    data.aws_iam_policy_document.alb.json,
    data.aws_iam_policy_document.cloudfront.json,
    ] : [
    data.aws_iam_policy_document.s3.json,
    data.aws_iam_policy_document.alb.json,
    data.aws_iam_policy_document.cloudfront.json,
    data.aws_iam_policy_document.external_readers.json
  ]
}
