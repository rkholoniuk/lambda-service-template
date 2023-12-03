terraform {
  backend "remote" {
    organization = "organization-name"

    workspaces {
      prefix = "lambda-service-template-"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "cloud-services" {
  name                 = "${var.service_name}-${var.stage}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

module "lambda" {
  source        = "./modules/lambda"
  service_name  = var.service_name
  region        = var.region 
  stage         = var.stage
  image_uri     = "${aws_ecr_repository.cloud-services.repository_url}:latest"
}

module "cloudwatch" {
  source          = "./modules/cloudwatch"
  service_name    = var.service_name
  stage           = var.stage 
  cron_expression = var.cron_expression
  lambda_arn      = module.lambda.lambda_arn
}
