export AWS_DEFAULT_REGION = us-east-1
export AWS_ACCOUNT = 123456789012

usage:       ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

deploy-image:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com
	docker build --tag monitor-service --file docker/Dockerfile --load .
	docker tag monitor-service:latest $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/monitor-service-prod:latest
	docker push $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/monitor-service-prod:latest
				
deploy-lambda:
	tarraform init
	terraform workspace select dev
	terraform apply --var-file=config/dev.tfvars
run:
	docker run -p 8080:8080 --env-file .env monitor-service
deploy-all: deploy-image deploy-lambda
.PHONY: usage push
