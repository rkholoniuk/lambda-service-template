variable "lambda_arn" {}
variable "stage" {}
variable "service_name" {}
variable "cron_expression" {
  description = "Cron expression for the CloudWatch event rule"
  type        = string
  default     = "cron(0/60 * ? * MON-FRI *)" # every hour on weekdays
}
