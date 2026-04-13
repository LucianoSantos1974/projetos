variable "project_name" {
    description = "Nome do projeto"
    type        = string
}

variable "region" {
    description = "Região default"
    type        = string
}

variable "tags" {
    description = "Tags default do projeto"
    type        = map(string)  
}

variable "path_file" {
  description = "Site de origem dos arquivos para download da B3"
  type        = string
}

variable "matriz_tax" {
  description = "Lista de taxas para download, abreviados."
  type        = list(string)
}
