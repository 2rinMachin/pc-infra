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
