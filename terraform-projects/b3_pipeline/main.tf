module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-${var.region}-bucket"
}

module "iam" {
  source              = "./modules/iam"
  project_name        = var.project_name
  bucket_arn          = module.s3.bucket_arn
  step_function_arn   = module.step_functions.step_function_arn
  lambda_function_arn = module.lambda.lambda_function_arn
  glue_job_arn        = module.glue.glue_job_arn
}

module "lambda" {
  source               = "./modules/lambda"
  project_name         = var.project_name
  b3_proccess_role_arn = module.iam.b3_proccess_role_arn
  matriz_tax           = var.matriz_tax
  path_file            = var.path_file
  bucket_name          = module.s3.bucket_name
  bucket_arn           = module.s3.bucket_arn
}

module "glue" {
  source               = "./modules/glue"
  project_name         = var.project_name
  bucket_name          = module.s3.bucket_name
  b3_proccess_role_arn = module.iam.b3_proccess_role_arn
}

module "step_functions" {
  source               = "./modules/stepfunctions"
  project_name         = var.project_name
  glue_job_name        = module.glue.glue_job_name
  lambda_function_name = module.lambda.lambda_function_name
  b3_proccess_role_arn = module.iam.b3_proccess_role_arn
}

module "scheduler" {
  source              = "./modules/scheduler"
  project_name        = var.project_name
  description         = "Arquivos da B3 de taxa. Executa Lambda e Glue às 21h de segunda a sexta."
  schedule_expression = "cron(0 21 ? * MON-FRI *)"

  targets = [
    {
      arn      = module.step_functions.step_function_arn
      role_arn = module.iam.b3_proccess_role_arn
    }
  ]
}