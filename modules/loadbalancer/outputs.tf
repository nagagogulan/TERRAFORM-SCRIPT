output "load_balancer_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.app_alb.id
}

output "load_balancer_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.app_alb.arn
}

output "load_balancer_zone_id" {
  description = "The zone id of the load balancer"
  value       = aws_lb.app_alb.zone_id
}

output "admin_tg_arn" {
  description = "The arn of the admin target group"
  value       = aws_lb_target_group.admin_tg.arn
}

output "payment_tg_arn" {
  description = "The arn of the payment target group"
  value       = aws_lb_target_group.payment_tg.arn
}

output "merchant_tg_arn" {
  description = "The arn of the merchant target group"
  value       = aws_lb_target_group.merchant_tg.arn
}

output "payout_tg_arn" {
  description = "The arn of the merchant target group"
  value       = aws_lb_target_group.payout_tg.arn
}


output "alb_dns_name" {
  description = "The dns name of application load balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "The id of application load balancer zone"
  value       = aws_lb.app_alb.zone_id
}


