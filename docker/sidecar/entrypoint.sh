#!/bin/sh

# Fail immediately if any command fails
set -e

echo "[Init] Starting sidecar container..."
echo "[Init] Fetching SSM Parameter S3_KEY_NAME: $S3_KEY_NAME, S3_KEY_VERSION: $S3_KEY_VERSION"

# Fetch S3 URL via AWS CLI instead of ECS secrets block
# This ensures we don't break ECS Validation rules when appending version numbers!
S3_URL=$(aws ssm get-parameter --name "${S3_KEY_NAME}:${S3_KEY_VERSION}" --query "Parameter.Value" --output text)

echo "[Init] Target S3 URL: $S3_URL"

# Download the file to the shared volume (/data is mounted to an ECS volume)
aws s3 cp "$S3_URL" /data/index.html

# Fix permissions so Nginx (UID 101 in alpine) can read the file
echo "[Init] Adjusting permissions for Nginx..."
chown -R 101:101 /data
chmod -R 755 /data

echo "[Init] Setup complete. Exiting successfully so Nginx can start."
