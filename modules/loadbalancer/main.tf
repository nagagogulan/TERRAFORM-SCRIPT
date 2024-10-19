resource "aws_lb" "app_alb" {
  name                       = "${var.env_name}-app-alb"
  load_balancer_type         = "application"
  internal                   = false
  security_groups            = var.loadbalancer_security_groups
  subnets                    = var.loadbalancer_subnets
  enable_deletion_protection = false

  access_logs {
    bucket  = var.load_balancer_logs_s3_bucket_id
    prefix  = "appx"
    enabled = true
  }

  tags = var.common_tags
}

  
// admin listener
resource "aws_lb_listener" "app_alb_listener_443_admin" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "8082"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_tg.arn
  }

  tags = var.common_tags
}
# // payment listener
resource "aws_lb_listener" "app_alb_listener_443_payment" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "8083"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payment_tg.arn
  }

  tags = var.common_tags
}

resource "aws_lb_listener" "app_alb_listener_443_merchant" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "8081"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.merchant_tg.arn
  }

  tags = var.common_tags
}

///listener rules
#resource "aws_lb_listener_rule" "admin_rule" {
#   listener_arn = aws_lb_listener.app_alb_listener_443_admin.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.admin_tg.arn
#   }

#   condition {
#     host_header {
#       values = [var.admin_domain_name]
#     }
#   }
# }

# resource "aws_lb_listener_rule" "payment_rule" {
#   listener_arn = aws_lb_listener.app_alb_listener_443_payment.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.payment_tg.arn
#   }

#   condition {
#     host_header {
#       values = [var.payment_domain_name]
#     }
#   }
# }

# resource "aws_lb_listener_rule" "merchant_rule" {
#   listener_arn = aws_lb_listener.app_alb_listener_443_merchant.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.merchant_tg.arn
#   }

#   condition {
#     host_header {
#       values = [var.merchant_domain_name]
#     }
#   }
# }



# # ///load balancer listener
# resource "aws_lb_listener" "app_alb_listeners" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#  default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
#   tags = var.common_tags
# }

# // admin listener
# resource "aws_lb_listener" "app_alb_listener_443_admin" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.admin_tg.arn
#   }

#   tags = var.common_tags
# }
# // payment listener
# resource "aws_lb_listener" "app_alb_listener_443_payment" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.payment_tg.arn
#   }

#   tags = var.common_tags
# }

# resource "aws_lb_listener" "app_alb_listener_443_merchant" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.merchant_tg.arn
#   }

#   tags = var.common_tags
# } r