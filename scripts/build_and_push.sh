#!/bin/bash
set -e

# Change directory to the terraform demo directory to fetch context
cd "$(dirname "$0")/../terraform/demo"

echo "Fetching ECR Repository URLs from Terraform..."
if ! APP_REPO_URL=$(terraform output -raw app_repository_url 2>/dev/null); then
  echo "Error: Could not retrieve app_repository_url. Did you run 'terraform apply' first?"
  exit 1
fi
SIDECAR_REPO_URL=$(terraform output -raw sidecar_repository_url)

# Extract registry URL and AWS Region from the APP_REPO_URL
REGISTRY_URL=$(echo $APP_REPO_URL | cut -d'/' -f1)
AWS_REGION=$(echo $REGISTRY_URL | cut -d'.' -f4)

echo "AWS Region: $AWS_REGION"
echo "App Repo: $APP_REPO_URL"
echo "Sidecar Repo: $SIDECAR_REPO_URL"

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REGISTRY_URL

IMAGE_TAG=$(date +%Y%m%d%H%M%S)

# Move to docker directory
cd ../../docker

echo "Building App (Nginx) Image..."
docker build -t $APP_REPO_URL:$IMAGE_TAG -t $APP_REPO_URL:latest ./nginx

echo "Building Sidecar (AWS CLI) Image..."
docker build -t $SIDECAR_REPO_URL:$IMAGE_TAG -t $SIDECAR_REPO_URL:latest ./sidecar

echo "Pushing App Image to ECR..."
docker push $APP_REPO_URL:$IMAGE_TAG
docker push $APP_REPO_URL:latest

echo "Pushing Sidecar Image to ECR..."
docker push $SIDECAR_REPO_URL:$IMAGE_TAG
docker push $SIDECAR_REPO_URL:latest

echo "Build and Push Completed Successfully."
echo "App tag: $IMAGE_TAG"