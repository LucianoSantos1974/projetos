# Package the Lambda function code
data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda_download.py"
  output_path = "${path.module}/lambda_download.zip"
}

# Lambda function
resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = "${var.project_name}-download-lambda"
  role             = var.b3_proccess_role_arn
  handler          = "lambda_download.lambda_handler"
  runtime          = "python3.14"
  source_code_hash = data.archive_file.this.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      PATH_FILE   = var.path_file
      MATRIZ_TAX  = jsonencode(var.matriz_tax)
    }
  }
}