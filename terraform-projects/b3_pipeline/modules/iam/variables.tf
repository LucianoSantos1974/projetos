variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "bucket_arn" {
  description = "ARN do bucket S3"
  type        = string
}

variable "step_function_arn" {
  description = "ARN do step function"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN do lambda"
  type        = string
}

variable "glue_job_arn" {
  description = "ARN do glue"
  type        = string
}

