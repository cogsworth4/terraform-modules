resource "aws_s3_bucket" "main" {
  bucket = local.name

  tags = {
    Name        = local.name
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "main-bucket-data-acl" {
  bucket = aws_s3_bucket.main.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main-bucket-sse-configuration" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block-all-access" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb-access-logs" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.alb-access-logs.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "alb-access-logs" {
  policy_id = "${aws_s3_bucket.main.id}-alb-access-logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]

    principals {
      identifiers = [data.aws_elb_service_account.main.arn]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.main.arn}",
    ]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
