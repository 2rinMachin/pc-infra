data "aws_lambda_function" "put_order_task_token" {
  function_name = "${var.project_name}-orders-${var.stage}-put_order_task_token"
}

locals {
  order_state_names = [
    "WaitForCook",
    "Cooking",
    "WaitForDispatcher",
    "Dispatching",
    "WaitForDeliverer",
    "Delivering",
    "Complete"
  ]

  order_states = {
    for i, name in local.order_state_names :
    name => {
      Type     = "Task"
      Resource = "arn:aws:states:::lambda:invoke.waitForTaskToken"
      Parameters = {
        FunctionName = data.aws_lambda_function.put_order_task_token.function_name
        Payload = {
          "tenant_id.$" : "$.tenant_id"
          "order_id.$" : "$.order_id"
          "task_token.$" : "$$.Task.Token"
        }
      }
      Next = i < length(local.order_state_names) - 1 ? local.order_state_names[i + 1] : "FinalStep"
    }
  }
}

resource "aws_sfn_state_machine" "order_workflow" {
  name     = "${var.project_name}-${var.stage}-orders-workflow"
  role_arn = var.labrole_arn

  definition = jsonencode({
    StartAt = "FinalStep"
    StartAt = "WaitForCook"
    States = merge(
      local.order_states,
      {
        FinalStep = {
          Type = "Pass"
          End  = true
        }
    })
  })
}
