module "kyc_storage_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = "${var.env_name}-${var.app_name}-kyc"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_policy      = false
  tags                     = merge(var.common_tags, { Name = "${var.env_name}-kyc-logs" })
}

module "document_storage_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = "${var.env_name}-${var.app_name}-documents"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_policy      = false
  tags                     = merge(var.common_tags, { Name = "${var.env_name}-documents" })
}

module "app_logs_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = "${var.env_name}-${var.app_name}-app-logs"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_policy      = false
  tags                     = merge(var.common_tags, { Name = "${var.env_name}-app-logs" })
}

module "load_balancer_logs_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = "${var.env_name}-${var.app_name}-abbb-logs"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_policy      = false
  tags                     = merge(var.common_tags, { Name = "${var.env_name}-abbb-logs" })
}

module "codepipeline_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = "${var.env_name}-${var.app_name}-codepipeline"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_policy      = false
  versioning = {
    enabled = true
  }
  lifecycle_rule = [
    {
      id      = "delete"
      enabled = true

      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]
  tags = merge(var.common_tags, { Name = "${var.env_name}-s3-codepipeline-logs" })
}

resource "aws_s3_bucket_cors_configuration" "kyc_storage_s3_bucket_cors" {
  bucket = module.kyc_storage_s3_bucket.s3_bucket_id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_cors_configuration" "document_storage_s3_bucket" {
  bucket = module.document_storage_s3_bucket.s3_bucket_id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_cors_configuration" "app_logs_s3_bucket" {
  bucket = module.app_logs_s3_bucket.s3_bucket_id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "kyc_storage_s3_bucket_policy" {
  bucket = module.kyc_storage_s3_bucket.s3_bucket_id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.env_name}-${var.app_name}-kyc",
                "arn:aws:s3:::${var.env_name}-${var.app_name}-kyc/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_policy" "documents_s3_bucket_policy" {
  bucket = module.document_storage_s3_bucket.s3_bucket_id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.env_name}-${var.app_name}-documents",
                "arn:aws:s3:::${var.env_name}-${var.app_name}-documents/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_policy" "app_logs_s3_bucket_policy" {
  bucket = module.app_logs_s3_bucket.s3_bucket_id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.env_name}-${var.app_name}-app-logs",
                "arn:aws:s3:::${var.env_name}-${var.app_name}-app-logs/*"
            ]
        }
    ]
}
EOF
}

data "aws_caller_identity" "current" {}
resource "aws_s3_bucket_policy" "alb_logs_s3_bucket_policy" {
  bucket = module.load_balancer_logs_s3_bucket.s3_bucket_id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::718504428378:root"
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::dev-appxpay-abbb-logs/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}

resource "aws_s3_bucket_policy" "codepipeline_s3_bucket_policy" {
  bucket = module.codepipeline_s3_bucket.s3_bucket_id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.env_name}-${var.app_name}-codepipeline",
                "arn:aws:s3:::${var.env_name}-${var.app_name}-codepipeline/*"
            ]
        }
    ]
}
EOF
}
