output "step_function_arn" {
  description = "ARN da State Machine do Step Functions"
  value       = aws_sfn_state_machine.pipeline.arn
}