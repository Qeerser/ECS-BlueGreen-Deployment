# AWS ECS Fargate Blue/Green Deployment with Sidecar Pattern

This repository contains a production-ready, highly secure, and cost-optimized infrastructure deployment for a web application using AWS ECS Fargate, provisioned via Terraform.

## Architecture Overview

The system architecture adheres strictly to the **AWS Well-Architected Framework**:

1.  **Network**: A custom VPC with Public, Private (App), and Private (DB) subnets across 2 Availability Zones. It utilizes a NAT Gateway for outbound internet access and an S3 Gateway Endpoint to securely route S3 traffic internally, saving NAT data transfer costs.
2.  **Compute Layer**: AWS ECS on Fargate. It runs serverless containers without managing EC2 instances.
3.  **Container Pattern (Sidecar)**: 
    *   **Sidecar Container**: A lightweight Alpine-based container with `aws-cli`. It reads an SSM Parameter at startup, downloads the target `index.html` from an S3 bucket, and places it into an ephemeral shared volume (`/data`).
    *   **App Container**: An Nginx container (`nginx-unprivileged:alpine`) lacking root access. It listens on port 8080. It mounts the shared volume and serves the downloaded `index.html`.
4.  **Deployment (Blue/Green)**: AWS CodeDeploy orchestrates zero-downtime updates by shifting traffic between two Target Groups (Blue and Green) on the Application Load Balancer.
5.  **Storage & Configuration**: S3 stores the static web assets (`v1` and `v2`). AWS Systems Manager (SSM) Parameter Store maintains the active S3 URI pointer.

## Design Decisions (The "Why")

*   **Decoupled Content & Compute**: Using the Sidecar pattern combined with SSM allows us to update the website's content (e.g., from `v1` to `v2`) **without rebuilding the Docker image**.
*   **Security (Least Privilege & Non-Root)**: The Nginx image is stripped of root privileges to minimize the attack surface. It listens on an unprivileged port (`8080`). All IAM roles utilize strict, scoped-down policies (e.g., read-only S3 access).
*   **Cost Optimization**: Migrating the Sidecar base image from `amazon/aws-cli` (~350MB) to `alpine:latest` (~50MB) vastly reduces pull times and ECR storage costs.

---

## Step-by-Step Execution Guide

### Phase 1: Initial Infrastructure Deployment

To solve the "Chicken and Egg" problem with ECS and ECR (ECS cannot start without images in ECR), we use a Two-Phase approach:

**1. Initialize Terraform & Create ECR Repositories first:**
```bash
cd terraform/demo
terraform init
terraform apply -target=module.ecr -auto-approve
```

**2. Build and Push Initial Images:**
```bash
cd ../../scripts
chmod +x build_and_push.sh
./build_and_push.sh
```
*(This script dynamically fetches the ECR endpoints from Terraform state, builds Nginx and Sidecar, and pushes them.)*

**3. Deploy the Remaining Infrastructure:**
```bash
cd ../terraform/demo
terraform apply -auto-approve
```
*(This provisions the VPC, ALB, S3, SSM, and the ECS Fargate cluster. Once finished, navigate to the ALB DNS name to view the `v1` site.)*

---

### Phase 2: Executing a Blue/Green Deployment

To perform a zero-downtime Blue/Green deployment without tearing down or rebuilding Terraform infrastructure:

**1. Upload `v2` to the S3 Bucket:**
```bash
aws s3 cp web/v2/index.html s3://<YOUR_BUCKET_NAME>/v2/index.html
```

**2. Update SSM Parameter Store:**
Navigate to the AWS Console -> Systems Manager -> Parameter Store. 
Update `/coda-interview/dev/s3_key` to point to: `s3://<YOUR_BUCKET_NAME>/v2/index.html`

**3. Trigger CodeDeploy:**
```bash
cd scripts
chmod +x deploy.sh
./deploy.sh
```
*(This script fetches the current Task Definition, registers a new identical revision to force ECS to refresh, injects it into `appspec.yaml`, and triggers CodeDeploy.)*

**4. Monitor the Deployment:**
Navigate to the AWS CodeDeploy Console. Traffic will seamlessly shift from the Blue target group to the Green target group serving the new content.

---

## Future Improvements (Production Readiness)

Given more time, the following enhancements would be added for a large-scale production environment:
*   **Edge Security & Caching**: Integrate AWS CloudFront (CDN) and WAF in front of the ALB.
*   **Observability**: Implement AWS X-Ray or OpenTelemetry for tracing, and set up CloudWatch Alarms for the Target Group 5xx error rates.
*   **State Management**: Move Terraform state to a remote backend (e.g., S3 + DynamoDB locking).
*   **Auto-Scaling**: Configure ECS Service Auto-Scaling based on CPU/Memory utilization.
