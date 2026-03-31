#!/bin/bash
set -e

# Navigate to terraform demo to fetch environment context
cd "$(dirname "$0")/../terraform/demo"

APP_NAME=$(terraform output -raw codedeploy_app_name)
DG_NAME=$(terraform output -raw codedeploy_deployment_group_name)
TASK_DEF_FAMILY=$(terraform output -raw ecs_task_definition_family)

# Since we just pushed "latest" tags to ECR, we can re-register the current task definition
# without changes. ECS will pull the new latest digests upon new task startup via CodeDeploy.
echo "Fetching current Task Definition for family: $TASK_DEF_FAMILY"
TASK_DEF_JSON=$(aws ecs describe-task-definition --task-definition $TASK_DEF_FAMILY --query 'taskDefinition' | jq 'del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .compatibilities, .registeredAt, .registeredBy)')

echo "Registering new Task Definition Revision..."
NEW_TASK_DEF_ARN=$(aws ecs register-task-definition --cli-input-json "$TASK_DEF_JSON" --query 'taskDefinition.taskDefinitionArn' --output text)

echo "New Task Definition ARN: $NEW_TASK_DEF_ARN"

# Return to root directory
cd ../../

echo "Preparing AppSpec for Blue/Green CodeDeploy deployment..."
# Inject the new Task Definition ARN into the appspec
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
echo "You can monitor the deployment progress in the AWS CodeDeploy Console (Blue/Green Deployment)."

# Clean up
rm -f appspec-deploy.yaml revision.json