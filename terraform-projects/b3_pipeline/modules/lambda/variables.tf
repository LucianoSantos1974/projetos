variable "bucket_name" {
  description = "Bucket para arquivos para calculo de safra de credito"
  type        = string
}

variable "bucket_arn" {
  description = "ARN do bucket S3"
  type        = string
}

variable "path_file" {
  description = "Site de origem dos arquivos para download da B3"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "b3_proccess_role_arn" {
  description = "ARN da role pra execução geral"
  type        = string
}

variable "matriz_tax" {
  description = "Lista de taxas para download, abreviados."
  type        = list(string)
}