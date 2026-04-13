# Outputs das credenciais (sensíveis)
output "s3_user_access_key_id" {
  value     = aws_iam_access_key.b3_user_key.id
  sensitive = true
}

output "s3_user_secret_access_key" {
  value     = aws_iam_access_key.b3_user_key.secret
  sensitive = true
}

output "s3_policy_arn" {
  description = "ARN da policy criada"
  value       = aws_iam_policy.b3_s3_policy.arn
}

output "b3_proccess_role_arn" {
  description = "ARN da role pra execução geral"
  value       = aws_iam_role.b3_proccess_role.arn
}