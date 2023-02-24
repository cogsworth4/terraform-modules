output "id" {
  value = aws_s3_bucket.main.id
}

output "bucket_name" {
  value = local.name
}

output "arn" {
  value = aws_s3_bucket.main.arn
}

output "group-usage-name" {
  value = aws_iam_group.usage.name
}
