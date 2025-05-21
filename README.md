# CI/CD Pipeline Stages Overview

This document outlines the key stages of our CI/CD pipeline for deploying a Node.js application to AWS EKS using GitLab CI/CD, Docker, Helm, and ArgoCD.

---

## Stage 1: Platform Checks (Kubernetes Cluster)

Before deploying to the development environment, ensure the AWS EKS cluster in the dev account is fully operational. This includes:

- The EKS worker nodes are in a `Ready` state.
- Essential Kubernetes components like CoreDNS, kube-proxy, and the API server are running correctly.
- The cluster health is verified to support smooth deployment and runtime operations.

---

## Stage 2: Validation (Dockerfile, Kubernetes Manifests, Policies, Snyk SAST)

This stage verifies the quality and security of your deployment configurations and codebase:

- Confirm the presence of a valid `Dockerfile` and Kubernetes manifests or Helm charts in the repository.
- Perform syntax validation on Kubernetes YAML files and Helm charts using tools like `helm lint`.
- Enforce security and compliance policies with Kyverno, e.g., restricting pods with elevated privileges or enforcing resource limits.
- Integrate Snyk for Static Application Security Testing (SAST) to detect vulnerabilities in the application code early.

---

## Stage 3: Build Artifact (Node.js Application Packaging)

In this phase, the application code is built and packaged into a deployable artifact:

- Run `npm run build` to compile or bundle the Node.js app if applicable.
- Package the application files into an archive (e.g., `app.tar.gz`) for artifact management or further use.
- This artifact serves as the basis for containerization and deployment.

---

## Stage 4: Packaging (Docker Image, Metadata, Helm Chart, Push to AWS ECR)

This stage prepares the application container and deployment resources:

- Build the Docker image from the Dockerfile with a tag that includes relevant metadata (e.g., commit SHA):  
  ```bash
  docker build -t $AWS_ECR_URI:$CI_COMMIT_SHA .


## Stage 5: Container Image Security Scanning (Snyk)

This stage focuses on ensuring the security of your container images before deployment:

- Perform a security scan on the Docker image using **Snyk** to detect known vulnerabilities (identified by CVE IDs) in the base image and included software packages.
- Identify outdated dependencies and libraries that may pose security risks.
- Generate detailed vulnerability reports to help developers and security teams take corrective actions early in the pipeline.
- Prevent deployment of images that do not meet security standards, reducing risks in production.

---

## Stage 6: Promote to Development Cluster with ArgoCD

This stage automates deployment and environment promotion using ArgoCD:

- Create or update a configuration file (e.g., `config.yaml`) specifying:
  - The application service name and Helm chart version.
  - The Terraform version used for infrastructure provisioning.
- Push this configuration file to a dedicated GitLab repository that ArgoCD monitors.
- ArgoCD detects the updated Helm chart version and triggers an automated deployment to the AWS EKS development cluster.
- After deployment, run automated post-deployment tests to verify the health and correctness of the deployment.
- Monitor the deployment and cluster resources through the ArgoCD UI or CLI, including pods, services, statefulsets, and configmaps.
- To promote the deployment to QA or other environments:
  - Update the configuration file with the corresponding environment’s details.
  - Push the changes to trigger a new pipeline, deploying the same Helm chart version to the target cluster/account.

This setup enables continuous deployment with version control, visibility, and automated rollout management across environments.
