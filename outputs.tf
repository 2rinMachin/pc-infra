output "sfn_orders_state_machine" {
  value = aws_sfn_state_machine.order_workflow.arn
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "amplify_dns_records" {
  value = [for sub_domain in aws_amplify_domain_association.domain.sub_domain : sub_domain.dns_record]
}

output "order_arrivals_topic_arn" {
  value = aws_sns_topic.order_arrivals.arn
}
