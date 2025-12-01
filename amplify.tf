locals {
  nextjs_build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - "corepack enable pnpm"
            - "pnpm install"
        build:
          commands:
            - "pnpm run build"
      artifacts:
        baseDirectory: "out"
        files:
          - "**/*"
      cache:
        paths:
          - "node_modules/**/*"
  EOT

  frontend_env = {
    NEXT_PUBLIC_TENANT_ID     = var.frontend_tenant_id
    NEXT_PUBLIC_USERS_URL     = var.users_api_url
    NEXT_PUBLIC_ORDERS_URL    = var.orders_api_url
    NEXT_PUBLIC_CATALOG_URL   = var.catalog_api_url
    NEXT_PUBLIC_ANALYTICS_URL = var.analytics_api_url
    NEXT_PUBLIC_WEBSOCKET_URL = var.websocket_url
    NEXT_PUBLIC_PUBLIC_URL    = "https://${var.customer_subdomain}.${var.domain}"
  }
}

resource "aws_amplify_app" "frontend" {
  name = "${var.project_name}-${var.stage}-frontend"

  repository  = var.frontend_repo
  oauth_token = var.github_token

  environment_variables = local.frontend_env
  build_spec            = local.nextjs_build_spec

  custom_rule {
    source = "/<*>"
    target = "/404.html"
    status = "404-200"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = "main"

  stage             = "PRODUCTION"
  enable_auto_build = true
}

resource "aws_amplify_domain_association" "domain" {
  app_id                = aws_amplify_app.frontend.id
  domain_name           = "${var.customer_subdomain}.${var.domain}"
  wait_for_verification = true

  certificate_settings {
    type                   = "CUSTOM"
    custom_certificate_arn = aws_acm_certificate.main.arn
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }
}

resource "aws_amplify_app" "frontend_restaurant" {
  name = "${var.project_name}-${var.stage}-frontend-restaurant"

  repository  = var.frontend_restaurant_repo
  oauth_token = var.github_token

  environment_variables = local.frontend_env
  build_spec            = local.nextjs_build_spec

  custom_rule {
    source = "/<*>"
    target = "/404.html"
    status = "404-200"
  }
}

resource "aws_amplify_branch" "main_restaurant" {
  app_id      = aws_amplify_app.frontend_restaurant.id
  branch_name = "main"

  stage             = "PRODUCTION"
  enable_auto_build = true
}

resource "aws_amplify_domain_association" "domain_restaurant" {
  app_id                = aws_amplify_app.frontend_restaurant.id
  domain_name           = "${var.restaurant_subdomain}.${var.domain}"
  wait_for_verification = true

  certificate_settings {
    type                   = "CUSTOM"
    custom_certificate_arn = aws_acm_certificate.main.arn
  }

  sub_domain {
    branch_name = aws_amplify_branch.main_restaurant.branch_name
    prefix      = ""
  }
}
