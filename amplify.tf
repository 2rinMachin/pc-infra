resource "aws_amplify_app" "frontend" {
  name = "${var.project_name}-${var.stage}-frontend"

  repository  = var.frontend_repo
  oauth_token = var.github_token

  environment_variables = {
    VITE_USERS_URL     = var.users_api_url
    VITE_ORDERS_URL    = var.orders_api_url
    VITE_CATALOG_URL   = var.catalog_api_url
    VITE_WEBSOCKET_URL = var.websocket_url
    VITE_PUBLIC_URL    = "https://${var.subdomain}.${var.domain}"
  }

  build_spec = <<-EOT
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
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = "main"

  stage             = "PRODUCTION"
  enable_auto_build = true
}

resource "aws_amplify_domain_association" "domain" {
  app_id                = aws_amplify_app.frontend.id
  domain_name           = "${var.subdomain}.${var.domain}"
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
