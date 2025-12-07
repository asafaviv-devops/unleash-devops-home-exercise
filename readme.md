# Unleash Devops Home Exercise

This repository contains an node Express server written in TypeScript that hosts an endpoint to check if a file exists in a specified S3 bucket. 

`GET /check-file?fileName=myfile.txt`

## Configuration

The following environment variables needs to be configured in the server:
- BUCKET_NAME
- PORT - (Default to 3000 if not specified)

## Tasks

### 1. Dockerization

Dockerize the server using best practices.

### 2. Continuous Integration (CI)

Set up a CI process using your preferred CI tool (e.g., GitHub Actions, GitLab CI, Azure Pipelines):

- Configure the CI pipeline to build and push a Docker image to a Docker registry on every commit to the main branch.

### 3. Continuous Deployment (CD)

Enhance the CI pipeline to include a CD stage:

- Automate the deployment of the Docker image to a cloud environment.
- Ensure the CD process deploys the service and its dependencies (e.g., the S3 bucket) in a robust, reproducible, and scalable manner.
- Apply infrastructure as code principles where appropriate.

**Note**: The infrastructure of the service (where this service runs) doesn't have to be managed as infrastructure as code within this repository.

---
