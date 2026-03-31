#!/bin/sh

# Fail immediately if any command fails
set -e

echo "[Init] Starting sidecar container..."
echo "[Init] Target S3 URL (Resolved by ECS): $S3_URL"

# Download the file to the shared volume (/data is mounted to an ECS volume)
aws s3 cp "$S3_URL" /data/index.html

# Fix permissions so Nginx (UID 101 in alpine) can read the file
echo "[Init] Adjusting permissions for Nginx..."
chown -R 101:101 /data
chmod -R 755 /data

echo "[Init] Setup complete. Exiting successfully so Nginx can start."
