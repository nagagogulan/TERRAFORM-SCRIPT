module "admin_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = "${var.env_name}-${var.app_name}-admin"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy     = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.common_tags
}

module "merchant_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = "${var.env_name}-${var.app_name}-merchant"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy     = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.common_tags
}

module "payment_api_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = "${var.env_name}-${var.app_name}-paymentapi"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy     = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "null_resource" "ecr_login" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${module.admin_ecr.repository_url}"
  }
}

resource "null_resource" "pull_image_admin" {
  provisioner "local-exec" {
    command = "docker pull nagagogulan/sep25-admin:latest || echo 'Failed to pull admin image'"
  }
}

resource "null_resource" "tag_image_admin" {
  provisioner "local-exec" {
    command = "docker tag nagagogulan/sep25-admin:latest ${module.admin_ecr.repository_url}:latest || echo 'Failed to tag admin image'"
  }
  depends_on = [null_resource.pull_image_admin]
}

resource "null_resource" "push_image_admin" {
  provisioner "local-exec" {
    command = "docker push ${module.admin_ecr.repository_url}:latest || echo 'Failed to push admin image'"
  }
  depends_on = [null_resource.tag_image_admin]
}

resource "null_resource" "pull_image_merchant" {
  provisioner "local-exec" {
    command = "docker pull nagagogulan/axp-merchant:tagname || echo 'Failed to pull merchant image'"
  }
}

resource "null_resource" "tag_image_merchant" {
  provisioner "local-exec" {
    command = "docker tag nagagogulan/axp-merchant:tagname ${module.merchant_ecr.repository_url}:latest || echo 'Failed to tag merchant image'"
  }
  depends_on = [null_resource.pull_image_merchant]
}

resource "null_resource" "push_image_merchant" {
  provisioner "local-exec" {
    command = "docker push ${module.merchant_ecr.repository_url}:latest || echo 'Failed to push merchant image'"
  }
  depends_on = [null_resource.tag_image_merchant]
}

resource "null_resource" "pull_image_payment" {
  provisioner "local-exec" {
    command = "docker pull santhhoshkumar/pg1:latest || echo 'Failed to pull payment image'"
  }
}

resource "null_resource" "tag_image_payment" {
  provisioner "local-exec" {
    command = "docker tag santhhoshkumar/pg1:latest ${module.payment_api_ecr.repository_url}:latest || echo 'Failed to tag payment image'"
  }
  depends_on = [null_resource.pull_image_payment]
}

resource "null_resource" "push_image_payment" {
  provisioner "local-exec" {
    command = "docker push ${module.payment_api_ecr.repository_url}:latest || echo 'Failed to push payment image'"
  }
  depends_on = [null_resource.tag_image_payment]
}
