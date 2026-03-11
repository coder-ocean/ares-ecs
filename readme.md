# Flask + Express Deployment on AWS ECS using Terraform

## Overview

This project demonstrates deploying a **Flask backend** and an **Express frontend** as Docker containers on AWS using Terraform.
Both services run on **AWS ECS (Fargate)** and are exposed through an **Application Load Balancer (ALB)**.

The infrastructure includes:

* VPC with public subnets
* Application Load Balancer
* ECS Cluster (Fargate)
* ECS Services (Frontend & Backend)
* Amazon ECR repositories for Docker images
* Terraform for infrastructure provisioning

---

# Architecture

```
Browser
   ↓
Application Load Balancer
   ↓
Frontend ECS Service (Express - port 3000)
   ↓
API Request /api
   ↓
ALB routing rule
   ↓
Backend ECS Service (Flask - port 5000)
```

ALB routing:

| Path    | Target           |
| ------- | ---------------- |
| `/`     | Frontend Service |
| `/api*` | Backend Service  |

---

# Technologies Used

* Terraform
* Docker
* Flask (Python)
* Express (Node.js)
* AWS ECS Fargate
* Amazon ECR
* Application Load Balancer
* AWS VPC

---

# Project Structure

```
ares-ecs
│
├── backend
│   ├── app.py
│   ├── business.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend
│   ├── app.js
│   ├── package.json
│   ├── views
│   │   └── index.ejs
│   └── Dockerfile
│
├── terraform
│   ├── provider.tf
│   ├── vpc.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── alb.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── README.md
```

---

# Backend

Flask application exposing an API endpoint:

```
GET /api
```

Returns:

```
{
  "data": [...]
}
```

Runs on port:

```
5000
```

---

# Frontend

Express application using **EJS templates**.

Flow:

```
Browser → Express → Flask API → Data returned → Render HTML
```

Frontend port:

```
3000
```

Environment variable used:

```
BACKEND_URL=http://ALB-DNS/api
```

---

# Prerequisites

Install the following tools:

* Terraform
* Docker
* AWS CLI
* Git

Configure AWS credentials:

```
aws configure
```

---

# Deployment Steps

## 1 Clone Repository

```
git clone https://github.com/coder-ocean/ares-ecs.git
cd ares-ecs
```

---

## 2 Initialize Terraform

```
terraform init
```

---

## 3 Create Infrastructure

```
terraform apply
```

Terraform provisions:

* VPC
* Subnets
* Security Groups
* ECS Cluster
* ALB
* Target Groups
* ECR repositories
* ECS Services

---

## 4 Build Docker Images

### Backend

```
docker build -t flask-backend backend
```

### Frontend

```
docker build -t express-frontend frontend
```

---

## 5 Login to Amazon ECR

```
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS \
--password-stdin <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
```

---

## 6 Push Images

Tag and push backend:

```
docker tag flask-backend:latest <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-backend:latest
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-backend:latest
```

Tag and push frontend:

```
docker tag express-frontend:latest <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/express-frontend:latest
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/express-frontend:latest
```

---

## 7 Redeploy ECS Services

Run again:

```
terraform apply
```

This updates ECS task definitions and deploys the latest images.

---

# Access the Application

After deployment, Terraform outputs the ALB DNS name.

Open:

```
http://ALB-DNS
```

Example:

```
http://flask-express-alb-xxxx.ap-south-1.elb.amazonaws.com
```

---

# Testing

Backend API:

```
http://ALB-DNS/api
```

Frontend UI:

```
http://ALB-DNS/
```

---

# Viewing Logs

Logs can be viewed in:

* ECS Console → Cluster → Service → Tasks
* Container Logs

Or in:

AWS CloudWatch Logs.

---

# Clean Up

To destroy infrastructure:

```
terraform destroy
```

---

# Learning Outcomes

This project demonstrates:

* Infrastructure as Code using Terraform
* Containerization using Docker
* Microservice architecture
* AWS ECS Fargate deployment
* ALB path-based routing
* Integration between frontend and backend services

---

# Author

GitHub: https://github.com/coder-ocean
