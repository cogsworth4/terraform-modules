# Access logs are stored in S3 every 5 minutes
module "alb-access-logs-bucket" {
  source = "../s3-alb-access-logs"
  count  = var.enable_access_logs ? 1 : 0

  environment  = var.environment
  project      = var.project
  cluster_name = local.name
  alb_arn      = aws_alb.alb.arn
}
