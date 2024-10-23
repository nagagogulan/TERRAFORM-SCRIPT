output "ecs_admin_service_name" {
  value = aws_ecs_service.admin_service.name
}

output "ecs_merchant_service_name" {
  value = aws_ecs_service.merchant_service.name
}

output "ecs_payment_service_name" {
  value = aws_ecs_service.payment_service.name
}

output "ecs_payout_service_name" {
  value = aws_ecs_service.payout_service.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs.name
}