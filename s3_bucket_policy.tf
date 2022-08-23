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
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${local.bucket}/${local.s3_logs_prefix}/*"]
  }
}

data "aws_iam_policy_document" "alb" {
  statement {
    principals {
      identifiers = [local.elb_service_account_arn]
      type        = "AWS"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${local.bucket}/${local.alb_logs_prefix}/AWSLogs/${local.account_id}/*"]
  }

  statement {
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${local.bucket}/${local.alb_logs_prefix}/AWSLogs/${local.account_id}/*"]
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
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${local.bucket}"]
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    principals {
      // Grant permission to awslogsdelivery by specifying the account's canonical ID
      // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
      identifiers = [lookup(local.canonical_ids, data.aws_partition.current.partition)]
      type        = "CanonicalUser"
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${local.bucket}/${var.cdn_logs_path}/*"]
  }
}

data "aws_iam_policy_document" "external_readers" {
  statement {
    principals {
      identifiers = concat(formatlist("arn:aws:iam::%s:root", local.reader_account_numbers), local.reader_full_arns)
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

locals {
  reader_full_arns       = [for r in local.readers : r if length(regexall("^arn:aws(-cn|-us-gov)?:", r)) > 0]
  reader_account_numbers = setsubtract(local.readers, local.reader_full_arns)
}
