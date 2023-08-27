variable "region" {
  default = "ap-south-1"
}

resource "aws_s3_bucket" "group1-static-website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "group1-static-website" {
  bucket = aws_s3_bucket.group1-static-website.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_website_configuration" "group1-static-website" {
  bucket = aws_s3_bucket.group1-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# S3 bucket ACL access

resource "aws_s3_bucket_ownership_controls" "group1-static-website" {
  bucket = aws_s3_bucket.group1-static-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "group1-static-website" {
  bucket = aws_s3_bucket.group1-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "group1-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.group1-static-website,
    aws_s3_bucket_public_access_block.group1-static-website,
  ]

  bucket = aws_s3_bucket.group1-static-website.id
  acl    = "public-read"
}


# s3 static website url

output "website_url" {
  value = "http://${aws_s3_bucket.group1-static-website.bucket}.s3-website.${var.region}.amazonaws.com"
}

/*
# S3 bucket policy
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.group1-static-website.id

  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.group1-static-website.bucket}/*",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
POLICY
}
*/