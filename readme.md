# Flask Express ECS Deployment

## Overview

This project deploys a Flask backend and Express frontend using Docker containers on AWS ECS using Terraform.

Infrastructure includes:

- VPC
- ECS Fargate cluster
- ECR repositories
- Application Load Balancer
- Docker image build and push
- Terraform-managed infrastructure

## Architecture

Client → ALB → Express Frontend → Flask Backend

Routes:

/ → Express Frontend  
/api → Flask Backend

## AWS Services Used

- ECS Fargate
- ECR
- VPC
- Application Load Balancer
- S3 (Terraform state)

## Project Structure

backend/ – Flask Docker container  
frontend/ – Express Docker container  
terraform/ – Infrastructure code

## Deployment Steps

1. Clone repository

2. Install dependencies

- Terraform
- AWS CLI
- Docker

3. Configure AWS credentials
