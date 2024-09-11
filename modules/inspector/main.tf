data "aws_caller_identity" "current" {}

resource "aws_inspector2_enabler" "inspector" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR"]
}