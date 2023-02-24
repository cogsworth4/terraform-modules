# Terraform Module: s3-alb-access-logs

All logs from load balancers are stored in this bucket.


## Usage

```terraform
module "s3-storage" {
  source = "github.com/dbl-works/terraform//s3-private?ref=v2021.11.13"

  # Required
  environment  = "staging"
  project      = "someproject"
  cluster_name = "someproject-staging-storage"
  alb_arn      = "arn:alb"
}
```


## Outputs

- `arn`: you probably want to pass this arn to ECS `grant_write_access_to_s3_arns`
- `kms-key-arn`: you probably want to pass this arn to ECS `kms_key_arns`
- `group-usage-name`: name of the AWS IAM group to grant usage permissions to the bucket
