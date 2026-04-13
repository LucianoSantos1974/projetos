# Usuário de execução restrito
resource "aws_iam_user" "b3_user" {
  name = "${var.project_name}-user"
}

# Chaves de acesso (Access Key e Secret Key)
resource "aws_iam_access_key" "b3_user_key" {
  user = aws_iam_user.b3_user.name
}

# Politicas
# Política customizada para acesso ao S3
resource "aws_iam_policy" "b3_s3_policy" {
  name = "${var.project_name}-b3-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  }
  )
}

# Política customizada para acesso ao lambda
resource "aws_iam_policy" "b3_lambda_policy" {
  name = "${var.project_name}-b3-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "LambdaAccess",
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/raw/*"
        ]
      }
    ]
  }
  )
}

# Política customizada para acesso ao glue
resource "aws_iam_policy" "b3_glue_policy" {
  name = "${var.project_name}-b3-glue-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "GlueAccess",
        Effect = "Allow",
        Action = [
          "glue:CreateDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:UpdateTable",
          "glue:BatchCreatePartition",
          "glue:GetPartitions",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:GetJob",
          "glue:StartJobRun"
        ],
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/glue/*",
          "${var.bucket_arn}/stage/*"
        ]
      }
    ]
  }
  )
}

# Política customizada para acesso ao EventBridge
resource "aws_iam_policy" "b3_scheduler_policy" {
  name = "${var.project_name}-b3-scheduler-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Scheduler",
        Effect = "Allow",
        Action = [
          "states:StartExecution"
        ],
        Resource = "*"
      }
    ]
  })
}

# Política customizada para acesso ao Stepfunctions
resource "aws_iam_policy" "b3_stepfunctions_policy" {
  name = "${var.project_name}-b3-stepfunctions-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "InvokeLambda",
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = var.lambda_function_arn
      },
      {
        Sid    = "GlueJobRun",
        Effect = "Allow",
        Action = [
          "glue:StartJobRun",
          "glue:GetJobRun"
        ],
        Resource = var.glue_job_arn
      },
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}

## Role com as politicas necessarias.
resource "aws_iam_role" "b3_proccess_role" {
  name = "${var.project_name}-b3_proccess-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { 
        Service = [
          "lambda.amazonaws.com",
          "glue.amazonaws.com",
          "states.amazonaws.com",
          "scheduler.amazonaws.com"
        ]
        },
      Action = "sts:AssumeRole"
    }]
  })
}

# Sequencia do attach
# Anexar política ao usuário
resource "aws_iam_user_policy_attachment" "b3_s3_attach" {
  user       = aws_iam_user.b3_user.name
  policy_arn = aws_iam_policy.b3_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "b3_lambda_attach" {
  role       = aws_iam_role.b3_proccess_role.name
  policy_arn = aws_iam_policy.b3_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_s3_attach" {
  role       = aws_iam_role.b3_proccess_role.name
  policy_arn = aws_iam_policy.b3_glue_policy.arn
}

resource "aws_iam_role_policy_attachment" "step_functions_attach" {
  role       = aws_iam_role.b3_proccess_role.name
  policy_arn = aws_iam_policy.b3_stepfunctions_policy.arn
}

resource "aws_iam_role_policy_attachment" "scheduler_attach" {
  role       = aws_iam_role.b3_proccess_role.name
  policy_arn = aws_iam_policy.b3_scheduler_policy.arn
}
