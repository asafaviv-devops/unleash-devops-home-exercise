File-Checker — Full CI/CD & Infrastructure Automation
--------------------------------------------------------

This repository provides a complete production-grade DevOps pipeline for deploying the File-Checker Node.js application into Amazon EKS using:

GitHub Actions CI/CD

Terraform for infrastructure

Amazon ECR for container registry

Amazon EKS (Kubernetes)

IRSA (IAM Roles for Service Accounts)

Amazon S3 (dynamic bucket creation)

The application checks whether a given file exists in an S3 bucket via:

GET /check-file?fileName=<filename>

Architecture Overview
--------------------
GitHub → CI Pipeline → ECR → Terraform → EKS → Kubernetes Deployment → IRSA → S3

Flow Summary:

Developer pushes to main

GitHub Actions builds & tests the app

Docker image is pushed to ECR

Terraform provisions/updates EKS cluster

Pipeline creates a unique S3 bucket

Kubernetes manifests are patched and deployed

Pod assumes IAM role via IRSA to access S3

Service is exposed through an AWS LoadBalancer

Application is validated with a curl request

 Repository Structure
---------------------
.
├── terraform/
│   ├── modules/eks/
│   └── envs/dev/
└── k8s_manifest_files/
    ├── namespace.yaml
    ├── deployment.yaml
    ├── service.yaml
    ├── service-account.yaml
.github/
└── workflows//File_Checker_ci_cd.yml

GitHub Actions Workflow
------------------------

The CI/CD pipeline is defined in:

.github/workflows/.yml


It includes 5 jobs:

1️⃣ BUILD

Checks out code

Generates image tag

Builds Docker image

docker build -t file-checker:<tag> .

2️⃣ TEST

Installs dependencies

Runs TypeScript compilation

Executes tests

Runs npm audit

3️⃣ PUSH TO ECR

This job:

✔ Logs in to AWS
✔ Ensures ECR repository exists
✔ Tags and pushes images (latest + versioned tag)

4️⃣DEPLOY INFRA (Terraform + S3)
------------------------------

This job performs:

✔ Terraform init/plan/apply

Deploys:

VPC

Subnets

EKS cluster

Node group

OIDC provider

IRSA IAM role (preconfigured inside Terraform)

S3 ReadOnly IAM policy attachment

✔ Creates a unique S3 bucket per pipeline run

Example:

file-checker-19994805887-68

✔ Exports the bucket name:
BUCKET_NAME=$S3_BUCKET_NAME

5️⃣ DEPLOY APPLICATION TO EKS

This job:

✔ Patches deployment.yaml with

Correct ECR image

The dynamic S3 bucket name

✔ Applies all Kubernetes manifests
✔ Waits for rollout
✔ Prints logs & verifies service
✔ Performs HTTP validation using curl

☁️ Infrastructure (Terraform)

Terraform handles all AWS resources including:

EKS Cluster

Control plane

Node groups

Networking

VPC

Subnets

Routing

IRSA

Terraform creates:

IAM role: filechker-dev-app-sa-role

Trust relationship with OIDC provider

Attaches AmazonS3ReadOnlyAccess

ServiceAccount annotation:

eks.amazonaws.com/role-arn: arn:aws:iam::<ACCOUNT_ID>:role/filechker-dev-app-sa-role

🐳 Application Deployment (Kubernetes)

Deployment includes:
___________________

Resource limits
resources:
  requests:
    cpu: "50m"
    memory: "128Mi"
  limits:
    cpu: "250m"
    memory: "256Mi"


 IRSA-enabled ServiceAccount

The pod receives temporary AWS credentials securely.

S3 Bucket Behavior

Each GitHub Actions run creates:

file-checker-<RUN_ID>-<RUN_NUMBER>


The bucket name is injected into deployment.yaml.

The app checks file existence:

GET /check-file?fileName=file.txt

Testing the Deployment
1️⃣ Get LoadBalancer hostname
kubectl get svc file-checker -n file-checker-app

2️⃣ Call application:
curl "http://<LB>:3000/check-file?fileName=file.txt"

Responses:
✔ File exists
✘ File not found

🔐 Security
___________

This setup ensures:

No AWS keys inside pods

Authentication uses IRSA

Temporary STS tokens

Least-privilege IAM policy

🏁 End-to-End Automation Summary

You now have:

✔ Full CI/CD automation
✔ Zero manual AWS configuration
✔ Dynamic bucket creation
✔ Secure pod credentials via IRSA
✔ Automated Kubernetes deployment
✔ Scalable & production-ready infrastructure
