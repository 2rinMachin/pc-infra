output "sfn_orders_state_machine" {
  value = aws_sfn_state_machine.order_workflow.arn
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.main.arn
}
