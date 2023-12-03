## Steps for Local Development and Testing
Running the Application:

Initialize the Python Environment:
```
eval "$(pyenv init -)"
python3 -m venv venv
source venv/bin/activate
```
Install Dependencies:
```
pip install -r requirements.txt
```
Start the application by running python app.py.
```
source .env.dev
python app.py
```
## Steps for Local Development and Testing Using Docker Compose

Preparing Environment Variables:
Please use templte to sample.env .env.* files

1. create .env.dev for local development 

Local Development and testing with AWS servides
Please use attaching .aws credentials (uncomment section)
- ${HOME}/.aws:/root/.aws/:ro

Steps for Testing the Service Locally:

Update Docker Compose Setup (if needed): Ensure your docker-compose.yml file mounts the .env as volumes inside your container. 
This setup allows you to test it locally.
```
volumes:
  - .env.dev:/var/task/.env.dev
```

Running the Service: 
After setting up your .env.dev and .env.prod files, 
start the service using Docker Compose with 

```
docker-compose up --build
```
Testing the Service: Use the following curl command:

```
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d {}
```
This mimics the way AWS Lambda functions are invoked, allowing you to test the service as if it were deployed in a Lambda environment.

## Deployment

The deployment process includes steps for deploying a Docker image to Amazon ECR (Elastic Container Registry) and deploying an AWS Lambda function via Terraform. 

Deployment Process Overview
This Deployment documentation provides an overview of key Terraform commands used in setting up and managing infrastructure. It explains how to authenticate with Terraform Cloud, initialize configurations, create and switch between workspaces, and generate execution plans using environment-specific variables. These steps are essential for managing multiple environments and ensuring that changes are correctly planned and applied.

### Terraform Commands Overview

1. **`terraform login`**:  
   Authenticate with Terraform Cloud to access remote workspaces.

2. **`terraform init`**:  
   Initialize the Terraform configuration, download plugins, and set up the working directory.

3. **`terraform workspace new dev`**:  
   Create a new workspace named `dev` for environment-specific configurations.

4. **`terraform workspace select dev`**:  
   Switch to the `dev` workspace to work in that environment.

5. **`terraform plan --var-file=config/dev.tfvars`**:  
   Generate an execution plan for the `dev` workspace using the variables in `dev.tfvars`.


```sh

terraform login
terraform init
terraform workspace new dev
terraform workspace select dev
terraform plan --var-file=config/dev.tfvars
```
### Deploying Necessary Services for Lambda

First, we need to deploy the necessary services to run the Lambda function. 
Since the AWS Lambda relies on ECR, 
we'll need to create the ECR repository first and then push the image to it.

```sh
terraform plan --var-file=config/dev.tfvars
terraform apply --var-file=config/dev.tfvars
```
ecr_repository_url = "123.dkr.ecr.us-east-1.amazonaws.com/lambda-service-template-dev"

### Building and Pushing the Docker Image

Next, build the Docker image and use the ECR URL (ecr_repository_url) for the service naming, such as lambda-service-template-dev. 
Then, update the build script accordingly:


```sh
   cd ..
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123.dkr.ecr.us-east-1.amazonaws.com
   docker build --tag lambda-service-template-dev --file docker/Dockerfile --load .
	docker tag lambda-service-template-dev:latest 123.dkr.ecr.us-east-1.amazonaws.com/lambda-service-template-dev:latest
	docker push 123.dkr.ecr.us-east-1.amazonaws.com/lambda-service-template-dev:latest
```

### Deploying the Lambda Function
Next, uncomment the module "lambda" section and rerun the commands.

```sh
cd infra  
terraform plan --var-file=config/dev.tfvars
terraform apply --var-file=config/dev.tfvars
```

### Verifying the Lambda Deployment
Next, verify if the Lambda function was deployed successfully. 
You can use AWS to invoke the Lambda function for this check.

### Deploying CloudWatch
Next, uncomment the module "cloudwatch" section and rerun the commands.

```sh
terraform plan --var-file=config/dev.tfvars
terraform apply --var-file=config/dev.tfvars
```

## Test locally
```
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d {}
```




