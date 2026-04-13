resource "aws_scheduler_schedule" "this" {
  name        = "${var.project_name}-scheduler"
  description = var.description

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  dynamic "target" {
    for_each = var.targets
    content {
      arn      = target.value.arn
      role_arn = target.value.role_arn
      input    = lookup(target.value, "input", null)
    }
  }
}