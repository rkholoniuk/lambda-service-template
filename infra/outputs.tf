# output "lambda_arn" {
#   value = module.lambda.lambda_arn
# }
output "ecr_repository_url" {
  value = aws_ecr_repository.cloud-services.repository_url
}