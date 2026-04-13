output "glue_job_name" {
  description = "Nome do Glue Job criado"
  value       = aws_glue_job.python_job.name
}

output "glue_job_arn" {
  description = "ARN do Glue Job criado"
  value       = aws_glue_job.python_job.arn
}
