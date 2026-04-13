variable "project_name" {
    description = "Nome do projeto"
    type        = string
}

variable "description" {
  description = "Descrição do scheduler"
  type        = string
}

variable "schedule_expression" {
  description = "Expressão cron para execução"
  type        = string
}

variable "targets" {
  description = "Lista de targets (Lambda, Glue, etc.)"
  type = list(object({
    arn      = string
    role_arn = string
    input    = optional(string)
  }))
}
