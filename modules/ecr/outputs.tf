output "admin_ecr_url" {
  value = module.admin_ecr.repository_url
}

output "merchant_ecr_url" {
  value = module.merchant_ecr.repository_url
}

output "payment_ecr_url" {
  value = module.payment_api_ecr.repository_url
}

output "payout_ecr_url" {
  value = module.payout_ecr.repository_url
}