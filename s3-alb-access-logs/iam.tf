resource "aws_iam_group" "usage" {
  name = "${aws_s3_bucket.main.id}-s3-usage"
}

resource "aws_iam_policy" "usage" {
  name        = "${aws_s3_bucket.main.id}-s3-usage"
  description = "For storing access logs for the ${aws_s3_bucket.main.id} ecs cluster"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:ListObjectVersions",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersion",
        "s3:PutObjectVersionAcl",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.main.id}",
        "arn:aws:s3:::${aws_s3_bucket.main.id}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "usage" {
  group      = aws_iam_group.usage.name
  policy_arn = aws_iam_policy.usage.arn
}
