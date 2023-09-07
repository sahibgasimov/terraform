# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {

  bucket = "www.${var.bucket_name}"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.common_tags
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.common_tags
}
/* 
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::www.${var.bucket_name}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        "arn:aws:cloudfront::${var.account_id}:distribution/${aws_cloudfront_distribution.www_s3_distribution.id}",
        "arn:aws:cloudfront::${var.account_id}:distribution/${aws_cloudfront_distribution.root_s3_distribution.id}"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "www_bucket_policy" {
  bucket = aws_s3_bucket.www_bucket.bucket
  policy = data.aws_iam_policy_document.s3_bucket_policy.json

  depends_on = [
    aws_s3_bucket.www_bucket,
    aws_cloudfront_distribution.www_s3_distribution
  ]
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_bucket.bucket
  policy = data.aws_iam_policy_document.s3_bucket_policy.json

  depends_on = [
    aws_s3_bucket.root_bucket,
    aws_cloudfront_distribution.www_s3_distribution
  ]
}

 */
