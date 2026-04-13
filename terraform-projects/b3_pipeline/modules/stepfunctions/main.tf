resource "aws_sfn_state_machine" "pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = var.b3_proccess_role_arn
  
  definition = jsonencode({
    Comment = "Pipeline Glue + Lambda"
    StartAt = "LambdaStep"
    States = {
      LambdaStep = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = var.lambda_function_name
          Payload      = {}
        }
        Next = "GlueJob"
      }
      GlueJob = {
        Type     = "Task"
        Resource = "arn:aws:states:::glue:startJobRun.sync"
        Parameters = {
          JobName = var.glue_job_name
        }
        End = true
      }
    }
  })
}
