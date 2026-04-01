#!/bin/bash
set -e

# Navigate to terraform demo to fetch the Single Source of Truth state
cd "$(dirname "$0")/../terraform/demo"

APP_NAME=$(terraform output -raw codedeploy_app_name)
DG_NAME=$(terraform output -raw codedeploy_deployment_group_name)

# Magic happens here: We just grab whatever Task Definition Terraform has already provisioned!
NEW_TASK_DEF_ARN=$(terraform output -raw ecs_task_definition_arn)

# Return to root directory
cd ../../

echo "Preparing AppSpec for Blue/Green CodeDeploy deployment..."
echo "Using Task Definition: $NEW_TASK_DEF_ARN"

# Inject the Terraform-managed Task Definition ARN into the appspec
sed "s|<TASK_DEFINITION>|$NEW_TASK_DEF_ARN|g" appspec.yaml > appspec-deploy.yaml

# Generate the deployment JSON parameter to safely pass yaml content via CLI
cat <<EOF > revision.json
{
  "revisionType": "AppSpecContent",
  "appSpecContent": {
    "content": $(jq -Rs . appspec-deploy.yaml)
  }
}
EOF

echo "Triggering CodeDeploy Deployment..."
DEPLOYMENT_ID=$(aws deploy create-deployment \
  --application-name $APP_NAME \
  --deployment-group-name $DG_NAME \
  --revision file://revision.json \
  --query 'deploymentId' \
  --output text)

echo "Deployment Triggered Successfully! Deployment ID: $DEPLOYMENT_ID"
echo "Monitor the deployment progress in the AWS CodeDeploy Console (Blue/Green Deployment)."

# Clean up
rm -f appspec-deploy.yaml revision.json