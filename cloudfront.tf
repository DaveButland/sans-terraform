locals {
	s3_public_origin_id = "S3-public.sans-website.com"
  s3_private_origin_id = "S3-private.sans-website.com"
}

resource "aws_cloudfront_origin_access_identity" "S3_public_origin_access_identity" {
  comment = "access-identity-public.sans-website.com.s3.amazonaws.com"

}

resource "aws_cloudfront_origin_access_identity" "S3_private_origin_access_identity" {
  comment = "access-identity-private.sans-website.com.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "sans_website" {

  origin {
    domain_name = "${aws_s3_bucket.public.bucket_domain_name}"
    origin_id   = "${local.s3_public_origin_id}"

    s3_origin_config {
		  origin_access_identity = "${aws_cloudfront_origin_access_identity.S3_public_origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  origin {
    domain_name = "${aws_s3_bucket.private.bucket_domain_name}"
    origin_id   = "${local.s3_private_origin_id}"

    s3_origin_config {
		  origin_access_identity = "${aws_cloudfront_origin_access_identity.S3_private_origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "sans-website"

	aliases = ["quyen-le-model.com"]
	viewer_certificate {
		acm_certificate_arn = "arn:aws:acm:us-east-1:739465383014:certificate/cebad9e0-76d9-4610-b7f3-b8d77bcd945d"
		minimum_protocol_version = "TLSv1.1_2016" 
  	ssl_support_method = "sni-only"
	}

/*
  logging_config {
    include_cookies = false
    bucket          = ""
    prefix          = ""
  }
*/

//  aliases = ["mysite.example.com", "yoursite.example.com"]

	default_cache_behavior {
  	allowed_methods  = ["GET", "HEAD"]
  	cached_methods   = ["GET", "HEAD"]
  	target_origin_id = "${local.s3_public_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
		compress 							 = true
  }

	ordered_cache_behavior {
    path_pattern     = "/private/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_private_origin_id}"
		trusted_signers = [ "self" ] 

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }

	ordered_cache_behavior {
    path_pattern     = "/thumbnail/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_private_origin_id}"
//		trusted_signers = [ "self" ] 

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
  	response_page_path = "/index.html"
		error_caching_min_ttl = 300 
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
  	response_page_path = "/index.html"
		error_caching_min_ttl = 300 
  }

	restrictions {
    geo_restriction {
			restriction_type = "none"
  //    restriction_type = "whitelist"
  //    locations        = ["GB"]
    }
  }

  price_class = "PriceClass_All"

//  viewer_certificate {
//    cloudfront_default_certificate = true
//  }
}

data "aws_iam_policy_document" "s3_public_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.S3_public_origin_access_identity.iam_arn}"]
    }
  }
}

data "aws_iam_policy_document" "s3_private_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.private.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.S3_private_origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "public" {
  bucket = "${aws_s3_bucket.public.id}"
  policy = "${data.aws_iam_policy_document.s3_public_policy.json}"
}

resource "aws_s3_bucket_policy" "private" {
  bucket = "${aws_s3_bucket.private.id}"
  policy = "${data.aws_iam_policy_document.s3_private_policy.json}"
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = "${aws_s3_bucket.public.id}"

  block_public_acls   = true
  block_public_policy = true
	ignore_public_acls = true 
	restrict_public_buckets = true 
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = "${aws_s3_bucket.private.id}"

  block_public_acls   = true
  block_public_policy = true
	ignore_public_acls = true 
	restrict_public_buckets = true 
}

output "sans_website" {
  value = "${aws_cloudfront_distribution.sans_website.domain_name}"
}
