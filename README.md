## About

Terraform module to create an S3 bucket for storing service logs:

* S3
* CloudFront
* ALB

### Params

* `bucket` - Bucket name.
* `force_destroy` - Allow remove bucket with its content (Default: `false`).
* `readers` - A list of AWS accounts who can read from bucket (Default: `[]`). If only the AWS account number is specified, the global `aws` partition is assumed.
* `cdn_logs_path` - Prefix for CloudFront logs (Default: `cdn`)
* `alb_logs_path` - Prefix for ALB logs (Default: `alb`)
* `s3_logs_path` - Prefix for S3 access logs (Default: `s3`)

## Usage

Example
```hcl
module "log_storage" {
  source = "github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs?ref=X.X.X" // see https://github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs/releases/latest
  bucket = "example-logs"
}

resource "aws_s3_bucket" "example" {
  bucket = "example"

  logging {
    target_bucket = module.log_storage.s3_logs_bucket
    target_prefix = module.log_storage.s3_logs_path
  }
}
```

Default values 
```hcl
module "log_storage" {
  source                  = "github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs?ref=X.X.X" // see https://github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs/releases/latest
  bucket                  = "example-logs"
  force_destroy           = false
  readers                 = []
}
```

## Outputs

* `bucket_arn` - S3 bucket ARN.

### Cloudfront

* `cdn_logs_bucket` - Bucket for CloudFront distribution.
* `cdn_logs_path` - Prefix for CloudFront logs (Default `cdn`).

### ALB

* `alb_logs_bucket` - Bucket for ALB.
* `alb_logs_path` - Prefix for ALB logs (Default `alb`).

### S3

* `s3_logs_bucket` - Bucket for S3 :) 
* `s3_logs_path` - Prefix for S3 access logs (Default `s3`).
