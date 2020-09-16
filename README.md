## About

Terraform module to create S3 bucket to store service logs:

* S3
* CloudFront 
* ALB

### Params

* `bucket` - Bucket name.
* `force_destroy` - Allow remove bucket with its content (Default `false`).

### Optional params with default values

* `cdn_logs_path` - Prefix for CloudFront logs (Default `cdn`)
* `alb_logs_path` - Prefix for ALB logs (Default `alb`)
* `s3_logs_path` - Prefix for S3 access logs (Default `s3`)

## Usage

Default 
```
module "log_storage" {
    source = "github.com/jetbrains-infra/terraform-aws-s3-bucket-for-logs"
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

## Outputs

* `s3_logs_bucket`
* `alb_logs_bucket`
* `cdn_logs_bucket`
* `s3_logs_path`
* `alb_logs_path`
* `cdn_logs_path`
* `bucket_arn`
