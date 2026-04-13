variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "bucket_name" {
  description = "Bucket para arquivos para calculo de safra de credito"
  type        = string
}

variable "b3_proccess_role_arn" {
  description = "ARN da role pra execução geral"
  type        = string
}

variable "glue_path_key" {
  description = "Caminho pra salvar o script"
  type = string
  default = "glue/scripts/"
}

variable "glue_py_file" {
  description = "Nome do arquivo python"
  type = string
  default = "glue_stage.py"
}

