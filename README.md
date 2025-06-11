# CloudNodeStack – DevOps Infrastructure Setup

This repo contains everything I built for Safle's DevOps assignment — a fully automated, scalable, and secure infrastructure for deploying a containerized Node.js application using Docker, Terraform, and GitHub Actions on AWS.

## Overview

- Containerized Node.js REST API using Docker
- Infrastructure on AWS using Terraform (VPC, EC2, RDS, ALB, ECR)
- CI/CD with GitHub Actions (Test, Build, Push to ECR)
- Secure setup with IAM, SSH-restricted access, and non-root containers

## Infrastructure Setup (Terraform)

Everything is defined in the `terraform/` directory. It provisions:

- VPC with public and private subnets
- Security groups for SSH, ALB, and RDS
- EC2 Auto Scaling Group behind an Application Load Balancer
- PostgreSQL RDS instance in private subnets
- ECR to host Docker images
- IAM roles with least-privilege access


CI/CD Pipeline
The pipeline is set up using GitHub Actions in .github/workflows/deploy.yml.

On every push to the main branch, it:

Installs dependencies and runs unit tests

Builds a Docker image

Pushes the image to AWS ECR

AWS credentials are securely passed using GitHub Secrets.



Docker Setup
The Node.js app is containerized using a minimal and secure Dockerfile:

Based on node:18-alpine

Runs as a non-root user

Exposes port 3000

There is also a docker-compose.yml for local testing with PostgreSQL.


Security Practices
IAM roles with least privilege

Security groups allow SSH only from my IP

RDS is private and encrypted

Docker containers run as a non-root user

Ready for HTTPS via ACM and ALB


Monitoring and Logging (Optional Extensions)
Monitoring and alerts were not fully implemented to keep the setup focused, but the system is prepared for:

CloudWatch Logs for EC2 and app

CloudWatch Alarms for CPU, memory, and errors

SNS integration for email or Slack alerts

Structured logging from the app in JSON format



Architecture Diagram


+----------------------------+
|        Public Subnet       |
|                            |
|  +----------------------+  |
|  |     ALB (HTTP/80)    |  |
|  +----------+-----------+  |
|             |              |
|   +---------+----------+   |
|   |     Auto Scaling    |  |
|   |     EC2 Group       |  |
|   +---------+----------+   |
|             |              |
+-------------|--------------+
              |
              v
+----------------------------+
|       Private Subnet       |
|  +----------------------+  |
|  |      RDS (PostgreSQL) | |
|  +----------------------+  |
+----------------------------+






