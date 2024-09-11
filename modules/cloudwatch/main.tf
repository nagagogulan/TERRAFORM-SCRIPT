resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization_too_high" {
  alarm_name          = "${var.env_name}-${var.app_name}-rds-cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Average database CPU utilization over last 5 minutes too high"
  alarm_actions       = [var.email_alert_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "rds_memory_freeable_too_low" {
  alarm_name          = "${var.env_name}-${var.app_name}-rds-lowFreeableMemory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Average database freeable memory is too low, performance may be negatively impacted."
  alarm_actions       = [var.email_alert_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "ecs_cpu_utilization_high" {
  alarm_name          = "${var.env_name}-${var.app_name}-ecs-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = 60

  alarm_description = "Average CPU utilization for ecs is high"

  alarm_actions = [var.email_alert_sns_topic_arn]

  dimensions = {
    ServiceName = var.ecs_service_name
  }
}


resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name          = "guardduty-event-rule"
  description   = "Trigger an event for GuardDuty findings"
  event_pattern = jsonencode({ source = ["aws.guardduty"] })
}

resource "aws_cloudwatch_event_target" "guardduty_event_target" {
  rule = aws_cloudwatch_event_rule.guardduty_event_rule.name
  arn  = var.email_alert_sns_topic_arn
}