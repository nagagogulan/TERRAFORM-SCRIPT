output "kyc_storage_s3_bucket_id" {
  description = "The id of the KYC S3 bucket"
  value       = module.kyc_storage_s3_bucket.s3_bucket_id
}

output "kyc_bucket_arn" {
  description = "The ARN of the KYC S3 bucket"
  value       = module.kyc_storage_s3_bucket.s3_bucket_arn
}

output "log_s3_bucket_id" {
  description = "The id of the log S3 bucket"
  value       = module.app_logs_s3_bucket.s3_bucket_id
}

output "document_storage_s3_bucket_id" {
  description = "The id of the log S3 bucket"
  value       = module.document_storage_s3_bucket.s3_bucket_id
}


output "app_log_bucket_arn" {
  description = "The ARN of the log S3 bucket"
  value       = module.app_logs_s3_bucket.s3_bucket_arn
}

output "load_balancer_logs_s3_bucket_id" {
  description = "The id of the load balancer logs S3 bucket"
  value       = module.load_balancer_logs_s3_bucket.s3_bucket_id
}

output "load_balancer_logs_bucket_arn" {
  description = "The ARN of the load balancer logs S3 bucket"
  value       = module.load_balancer_logs_s3_bucket.s3_bucket_arn
}

output "document_storage_s3_bucket_logs_arn" {
  description = "The ARN of the document storage S3 bucket"
  value       = module.document_storage_s3_bucket.s3_bucket_arn
}