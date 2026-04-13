variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "glue_job_name" {
    description = "Nome do processo GLUE"
    type = string
}

variable "lambda_function_name" {
    description = "Nome da função LAMBDA"
    type = string
}

variable "b3_proccess_role_arn" {
  description = "ARN da role pra execução geral"
  type        = string
}
