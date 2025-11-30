variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "pizzacold"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "labrole_arn" {
  type = string
}

variable "domain" {
  type        = string
  description = "Domain to use for SSL certificates"
}

variable "subdomain" {
  type    = string
  default = "pizzahut"
}


variable "product_images_bucket_name" {
  type    = string
  default = "product-images"
}

variable "ingesta_bucket_name" {
  type    = string
  default = "ingesta"
}


variable "frontend_repo" {
  type    = string
  default = "https://github.com/2rinMachin/pc-front"
}

variable "github_token" {
  type        = string
  description = "GitHub access token for the frontend"
}


variable "users_api_url" {
  type = string
}

variable "orders_api_url" {
  type = string
}

variable "catalog_api_url" {
  type = string
}

variable "analytics_api_url" {
  type = string
}

variable "websocket_url" {
  type = string
}

variable "export_data_schedule" {
  type    = string
  default = "rate(5 minutes)"
}
