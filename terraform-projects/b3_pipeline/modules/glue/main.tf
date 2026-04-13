# Upload do script local para o S3
resource "aws_s3_object" "python_script" {
  bucket = var.bucket_name
  key    = "${var.glue_path_key}${var.glue_py_file}"
  source = "${path.module}/${var.glue_py_file}"  # caminho local
}

# Job no Glue
resource "aws_glue_job" "python_job" {
  name     = "${var.project_name}-stage_analysis-glue"
  role_arn = var.b3_proccess_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_object.python_script.bucket}/${aws_s3_object.python_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"       = "s3://${aws_s3_object.python_script.bucket}/glue/temp/"
    "--job-language"  = "python"
    "--ENV_BUCKET"    = var.bucket_name
    "--ENV_PROJECT"   = var.project_name
    "--ENV_RAW"       = "b3-download-files-us-east-1-bucket/raw/input/"
    "--ENV_STAGE"     = "b3-download-files-us-east-1-bucket/stage/"
  }

  timeout = 10
  max_capacity = 2
}