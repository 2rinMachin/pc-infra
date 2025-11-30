data "aws_lambda_function" "export_users" {
  function_name = "${var.project_name}-ingesta-${var.stage}-export_users"
}

data "aws_lambda_function" "export_orders" {
  function_name = "${var.project_name}-ingesta-${var.stage}-export_orders"
}

data "aws_lambda_function" "export_catalog" {
  function_name = "${var.project_name}-ingesta-${var.stage}-export_catalog"
}

resource "aws_cloudwatch_event_rule" "export_data_schedule" {
  name                = "${var.project_name}-${var.stage}-export-data"
  schedule_expression = var.export_data_schedule
}

resource "aws_cloudwatch_event_target" "export_users" {
  rule      = aws_cloudwatch_event_rule.export_data_schedule.name
  target_id = "${var.project_name}-${var.stage}-export-users"
  arn       = data.aws_lambda_function.export_users.arn
  role_arn  = var.labrole_arn
}

resource "aws_cloudwatch_event_target" "export_orders" {
  rule      = aws_cloudwatch_event_rule.export_data_schedule.name
  target_id = "${var.project_name}-${var.stage}-export-orders"
  arn       = data.aws_lambda_function.export_orders.arn
  role_arn  = var.labrole_arn
}

resource "aws_cloudwatch_event_target" "export_catalog" {
  rule      = aws_cloudwatch_event_rule.export_data_schedule.name
  target_id = "${var.project_name}-${var.stage}-export-catalog"
  arn       = data.aws_lambda_function.export_catalog.arn
  role_arn  = var.labrole_arn
}
