resource "aws_s3_bucket" "mostperfect_bucket" {
  bucket = "www.mostperfect.net"
  acl    = "public-read"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
        "arn:aws:s3:::www.mostperfect.net/*"
      ]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "mostperfect_root_bucket" {
  bucket = "mostperfect.net"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "http://www.mostperfect.net"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.mostperfect_bucket.id}"
  key          = "index.html"
  source       = "html/index.html"
  etag         = "${md5(file("html/index.html"))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "cx_oracle_howto_html" {
  bucket       = "${aws_s3_bucket.mostperfect_bucket.id}"
  key          = "blog/2010/07/28/installing-cx_oracle-on-windows/index.html"
  source       = "html/cx_oracle_howto.html"
  etag         = "${md5(file("html/cx_oracle_howto.html"))}"
  content_type = "text/html"
}

resource "aws_route53_record" "website_route53_record" {
  zone_id = "${data.aws_route53_zone.mostperfect_net.zone_id}"
  name    = "mostperfect.net"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.mostperfect_bucket.website_domain}"
    zone_id                = "${aws_s3_bucket.mostperfect_bucket.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_website_route53_record" {
  zone_id = "${data.aws_route53_zone.mostperfect_net.zone_id}"
  name    = "www.mostperfect.net"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.mostperfect_bucket.website_domain}"
    zone_id                = "${aws_s3_bucket.mostperfect_bucket.hosted_zone_id}"
    evaluate_target_health = false
  }
}
