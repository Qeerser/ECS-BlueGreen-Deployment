# AWS ECS Fargate Blue/Green Deployment with Sidecar Pattern

This repository contains a production-ready, highly secure, and cost-optimized infrastructure deployment for a web application using AWS ECS Fargate, provisioned via Terraform.

## Architecture Overview

The system architecture adheres strictly to the **AWS Well-Architected Framework**:

1.  **Network**: A custom VPC with Public, Private (App), and Private (DB) subnets across 2 Availability Zones. It utilizes a NAT Gateway for outbound internet access and an S3 Gateway Endpoint to securely route S3 traffic internally, saving NAT data transfer costs.
2.  **Compute Layer**: AWS ECS on Fargate. It runs serverless containers without managing EC2 instances. Configured with **Auto Scaling** (Target Tracking for CPU utilization) and High Availability (min_capacity = 2).
3.  **Container Pattern (Sidecar)**: 
    *   **Sidecar Container**: A lightweight Alpine-based container with `aws-cli`. It reads an SSM Parameter at startup, downloads the target `index.html` from an S3 bucket, and places it into an ephemeral shared volume (`/data`).
    *   **App Container**: An Nginx container (`nginx-unprivileged:alpine`) lacking root access. It listens on port 8080. It mounts the shared volume and serves the downloaded `index.html`.
4.  **Deployment (Blue/Green)**: AWS CodeDeploy orchestrates zero-downtime updates by shifting traffic between two Target Groups (Blue and Green) on the Application Load Balancer.
5.  **Storage & Configuration**: S3 stores the static web assets (`v1` and `v2`). AWS Systems Manager (SSM) Parameter Store maintains the active S3 URI pointer.

## Design Decisions (The "Why")

*   **Infrastructure as the Single Source of Truth (GitOps)**: Changing the `app_version` in `terraform.tfvars` automatically updates the SSM Parameter Store and generates a new ECS Task Definition seamlessly.
*   **Security (Least Privilege & Non-Root)**: The Nginx image is stripped of root privileges to minimize the attack surface. It listens on an unprivileged port (`8080`). All IAM roles utilize strict, scoped-down **Inline Policies** (e.g., S3 access is restricted to the specific Bucket ARN, SSM restricted to the specific Parameter ARN, and ECR access restricted to the repository namespace).
*   **Decoupled Content**: Using the Sidecar pattern combined with Terraform's state management allows us to effortlessly roll out new website content without rebuilding Docker images.
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
*(This script dynamically fetches the ECR endpoints from Terraform state, builds Nginx and Sidecar, and pushes them into the secured ECR namespaces.)*

**3. Deploy the Remaining Infrastructure:**
```bash
cd ../terraform/demo
terraform apply -auto-approve
```
*(This provisions the VPC, ALB, Auto Scaling Groups, S3, SSM, and the ECS Fargate cluster. Navigate to the ALB DNS name to view the site.)*

---

### Phase 2: Executing a Blue/Green Deployment

To perform a zero-downtime Blue/Green deployment using Infrastructure as Code principles:

**1. Bump Application Version:**
Open `terraform/demo/terraform.tfvars` and change `app_version` to `"2"`.

**2. Apply the Infrastructure State:**
```bash
cd terraform/demo
terraform apply -auto-approve
```
*(Terraform dynamically updates the SSM Parameter Store and generates a new ECS Task Definition Revision attached to the new parameter context.)*

**3. Trigger CodeDeploy:**
```bash
cd ../../scripts
chmod +x deploy.sh
./deploy.sh
```
*(This lightweight script simply fetches the latest Task Definition ARN directly from Terraform State, injects it into `appspec.yaml`, and triggers CodeDeploy.)*

**4. Monitor the Deployment:**
Navigate to the AWS CodeDeploy Console. Traffic will seamlessly shift from the Blue target group to the Green target group serving the new content.

---

## Future Improvements (Production Readiness)

Given more time, the following enhancements would be added for a large-scale production environment:
*   **Edge Security & Caching**: Integrate AWS CloudFront (CDN) and WAF in front of the ALB.
*   **Observability**: Implement AWS X-Ray or OpenTelemetry for tracing, and set up CloudWatch Alarms for the Target Group 5xx error rates.
*   **State Management**: Move Terraform state to a remote backend (e.g., S3 + DynamoDB locking).
