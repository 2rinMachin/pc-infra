resource "aws_sns_topic" "order_arrivals" {
  name = "${var.project_name}-${var.stage}-order-arrivals"
}
