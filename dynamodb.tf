resource "aws_dynamodb_table" "tenants" {
  name         = "${var.project_name}-${var.stage}-tenants"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "tenant_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "products" {
  name         = "${var.project_name}-${var.stage}-products"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "tenant_id"
  range_key = "product_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }

  attribute {
    name = "product_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "users" {
  name         = "${var.project_name}-${var.stage}-users"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "tenant_id"
  range_key = "user_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "tenant-email-idx"
    hash_key        = "tenant_id"
    range_key       = "email"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "session_tokens" {
  name         = "${var.project_name}-${var.stage}-session-tokens"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "token"

  attribute {
    name = "token"
    type = "S"
  }

  attribute {
    name = "tenant_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "tenant-user-idx"
    hash_key        = "tenant_id"
    range_key       = "user_id"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "orders" {
  name         = "${var.project_name}-${var.stage}-orders"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "tenant_id"
  range_key = "order_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }

  attribute {
    name = "order_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "order_subscriptions" {
  name         = "${var.project_name}-${var.stage}-ws-order-subscriptions"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "tenant_id"
  range_key = "connection_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }

  attribute {
    name = "connection_id"
    type = "S"
  }

  global_secondary_index {
    name            = "connection-id-index"
    hash_key        = "connection_id"
    projection_type = "ALL"
  }
}

