locals {
  admin_container_name    = "${var.env_name}-${var.app_name}-admin-app"
  merchant_container_name = "${var.env_name}-${var.app_name}-merchant-app"
  payment_container_name  = "${var.env_name}-${var.app_name}-payment-app"
  payout_container_name   = "${var.env_name}-${var.app_name}-payout-app"
}

resource "aws_cloudwatch_log_group" "admin_laravel_log_group" {
  name              = "/ecs/admin-app"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "merchant_log_group" {
  name              = "/ecs/merchant-app"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "payment_log_group" {
  name              = "/ecs/payment-app"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "payout_log_group" {
  name              = "/ecs/payout-app"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "admin_task_definition" {
  family                = "${var.env_name}-${var.app_name}-admin-task"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${local.admin_container_name}",
      "image": "${var.admin_ecr_url}",
      "essential": true,
      "cpu": 0,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "KYC_BUCKET_NAME", "value": "${var.kyc_bucket_name}"},
        {"name": "DOCUMENT_BUCKET_NAME", "value": "${var.document_bucket_name}"}
      ],
      "secrets": [
        {
          "name": "DB_CREDENTIALS",
          "valueFrom": "${var.db_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.admin_laravel_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "admin"
        }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
}

resource "aws_ecs_service" "admin_service" {
  name                   = "${var.env_name}-${var.app_name}-admin-service"
  cluster                = aws_ecs_cluster.ecs.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.admin_task_definition.arn
  desired_count          = 5
  enable_execute_command = true
  wait_for_steady_state  = false

  network_configuration {
    security_groups  = var.ecs_cluster_security_groups
    subnets          = var.ecs_cluster_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.admin_tg_arn
    container_name   = local.admin_container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.admin_task_definition]
}

resource "aws_ecs_task_definition" "merchant_task_definition" {
  family                = "${var.env_name}-${var.app_name}-merchant-task"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${local.merchant_container_name}",
      "image": "${var.merchant_ecr_url}",
      "essential": true,
      "cpu": 0,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "KYC_BUCKET_NAME", "value": "${var.kyc_bucket_name}"},
        {"name": "DOCUMENT_BUCKET_NAME", "value": "${var.document_bucket_name}"}
      ],
      "secrets": [
        {
          "name": "DB_CREDENTIALS",
          "valueFrom": "${var.db_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.merchant_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "merchant"
        }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
}

resource "aws_ecs_service" "merchant_service" {
  name                   = "${var.env_name}-${var.app_name}-merchant-service"
  cluster                = aws_ecs_cluster.ecs.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.merchant_task_definition.arn
  desired_count          = 5
  enable_execute_command = true
  wait_for_steady_state  = false

  network_configuration {
    security_groups  = var.ecs_cluster_security_groups
    subnets          = var.ecs_cluster_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.merchant_tg_arn
    container_name   = local.merchant_container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.merchant_task_definition]
}

resource "aws_ecs_task_definition" "payment_task_definition" {
  family                = "${var.env_name}-${var.app_name}-payment-task"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${local.payment_container_name}",
      "image": "${var.payment_ecr_url}",
      "essential": true,
      "cpu": 0,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "KYC_BUCKET_NAME", "value": "${var.kyc_bucket_name}"},
        {"name": "DOCUMENT_BUCKET_NAME", "value": "${var.document_bucket_name}"}
      ],
      "secrets": [
        {
          "name": "DB_CREDENTIALS",
          "valueFrom": "${var.db_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.payment_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "payment"
        }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
}

resource "aws_ecs_service" "payment_service" {
  name                   = "${var.env_name}-${var.app_name}-payment-service"
  cluster                = aws_ecs_cluster.ecs.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.payment_task_definition.arn
  desired_count          = 5
  enable_execute_command = true
  wait_for_steady_state  = false

  network_configuration {
    security_groups  = var.ecs_cluster_security_groups
    subnets          = var.ecs_cluster_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.payment_tg_arn
    container_name   = local.payment_container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.payment_task_definition]
}

resource "aws_ecs_task_definition" "payout_task_definition" {
  family                = "${var.env_name}-${var.app_name}-payout-task"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${local.payout_container_name}",
      "image": "${var.payout_ecr_url}",
      "essential": true,
      "cpu": 0,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "KYC_BUCKET_NAME", "value": "${var.kyc_bucket_name}"},
        {"name": "DOCUMENT_BUCKET_NAME", "value": "${var.document_bucket_name}"}
      ],
      "secrets": [
        {
          "name": "DB_CREDENTIALS",
          "valueFrom": "${var.db_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.payout_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "payout"
        }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
}

resource "aws_ecs_service" "payout_service" {
  name                   = "${var.env_name}-${var.app_name}-payout-service"
  cluster                = aws_ecs_cluster.ecs.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.payout_task_definition.arn
  desired_count          = 5
  enable_execute_command = true
  wait_for_steady_state  = false

  network_configuration {
    security_groups  = var.ecs_cluster_security_groups
    subnets          = var.ecs_cluster_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.payout_tg_arn
    container_name   = local.payout_container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.payout_task_definition]
}
