**Application Deployment: Containerization, IaC, K8s & CI/CD** - A complete CI/CD pipeline using Docker, Terraform, GitHub Actions (CI), and Argo CD (CD) to deploy a simple “Hello, World!” application on AWS EKS using Helm charts.

**Prerequisites - Tools**
AWS CLI
Terraform (v1.x recommended)
kubectl
Helm
Docker
Git

**Step by Step Demonstration of the Project Overview** - 

1. **Web Application (App Layer)**
Create a simple app (Node.js or Python Flask) that displays: “Hello, World!”
This is your base application — the starting point for the pipeline.

2. **Dockerization (Container Layer)**
Write a Dockerfile to containerize your app.
Example: build a small lightweight image (python:3.9-alpine or node:18-alpine).
The container image should run the app on a specific port (e.g., 5000 for Flask, 3000 for Node).

3. **Infrastructure – Terraform + AWS EKS (Infrastructure Layer)**
Use Terraform to:
Provision an EKS Cluster (Elastic Kubernetes Service) on AWS.
Create Node Groups with these requirements:
Instance type: t3.small
Minimum nodes: 1
Maximum nodes: 4
Auto-scaling enabled.
Set up networking (VPC, subnets, etc.) if not already existing.
Deploy ALB (Application Load Balancer) for external access.

4. **Kubernetes Deployment (Orchestration Layer)**
Write Kubernetes manifests or HELM charts for:
Deployment (to run pods)
Service (to expose pods internally)
Ingress/ALB (to expose app externally)
HPA (Horizontal Pod Autoscaler) for auto-scaling pods
Based on 50% CPU or Memory utilization
Max 3 pods per node
Deploy the Dockerized app to EKS.

5. **CI/CD with GitOps (Automation Layer)**
we are using a modern GitOps flow:

 a) **CI (Continuous Integration) — GitHub Actions**
When code is pushed to the gitops branch:
Build Docker image from Dockerfile.
Tag it (e.g., v1.0, latest).
Push image to AWS ECR.
Update HELM values or manifest image tag automatically.

 b) **CD (Continuous Deployment) — Argo CD**
Argo CD watches your GitOps repo (manifests/HELM charts).
When it detects a change (e.g., new image tag in HELM values.yaml),
it automatically:
Syncs the changes to the EKS cluster.
Deploys the updated app image.
This makes your Kubernetes cluster always reflect Git state (core GitOps principle)


**Repository Structure**
This repo uses a two-branch GitOps model:

**main branch** - Contains everything related to the app:

/app             → Application code (Flask / Node)
/Dockerfile      → Docker image definition
/helm/           → Helm chart templates (non-prod)
/terraform/      → Terraform to provision AWS EKS
.gitignore
README.md

**gitops branch** Contains ONLY Helm charts, which Argo CD watches:

/helm/values.yaml
/helm/templates/
Argo CD continuously syncs this branch to the Kubernetes cluster.
GitHub Actions updates image tags here

**Setting Up the Environment**

1. **Clone the repository**
git clone https://github.com/ureachbhargavi/tech-challenge2.git

2. **cd tech-challenge2**

3. **Check out the correct branch**
For infrastructure, app code:
git checkout main
For GitOps-managed manifests:
git checkout gitops

4. **Install dependencies**
   
5. **Test Docker build locally**
docker build -t hello-app:latest .
docker run -p 8080:8080 hello-app:latest
Access your application using your host machine IP Address:Application port


**Terraform Infrastructure**
Terraform provisions your full AWS infrastructure:

1. VPC module – Creates VPC, subnets (public/private), route tables, NAT gateways etc

2. EKS module – Provisions EKS control plane, worker node group(s)

3. Worker node group configured with instance_type = t3.small

4. Auto-scaling group of nodes: minimum 1, maximum 4

5. IAM roles and policies – Defines roles for EKS, node-group, service accounts, ECR push/pull permissions

6. ECR repository module – Creates an ECR repo to host Docker images

7. ALB/LoadBalancer module – Creates ALB (if using AWS LoadBalancer Controller) or ensures Service type=LoadBalancer for your app

8. Outputs

Useful information exposed:
Cluster endpoint
Kubeconfig
ECR repo URL

**Deploy your application - K8s Configuration**

1. Verify helm installation in your local

2. Inside your tech-challenge directory, run:

3. helm create helm-chart

4. This will generate a folder structure like: helm creates default files 

helm-chart/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── hpa.yaml
    
5. Configure deployment yaml, service.yaml and values.yaml file to define which docker image to run, desired state, your ECR details etc.,

6. Deploy your application using helm install flask-app ./helm-chart

7. Check Deployment & Pods - Kubectl get svc - This confirms your AWS Load Balancer is working and publicly exposing your Flask app

8. Open your browser and hit ALB DNS to access your application


**CI/CD Workflow**
🔵 **CI: GitHub Actions (main branch)**

1. Whenever you push/merge to main, GitHub Actions:

2. Checks out the app code

3. Builds Docker image

4. Logs into AWS ECR

5. Pushes image to ECR using a unique tag 

6. Switches to gitops branch

7. Updates values.yaml with the new image tag

8. Commits & pushes the update

9. This automatically triggers Argo CD → Cluster deployment

**Argo CD Sync Process**

1. GitHub Actions updates image tag in gitops/helm/values.yaml

2. Argo CD detects commit in the gitops branch

3. Argo CD pulls Helm chart

4. Argo CD renders templates

5. Argo CD applies Deployment/Service/HPA to EKS

6. Kubernetes pulls new ECR image

7. Rolling update takes place

**This provides a modern GitOps approach using github actions and CI/CD** 
Why this model is effective

1. Decouples image build (CI) from deployment orchestration (CD).

2. Ensures that the cluster state is always declared in Git: whatever is in Git is what should be on the cluster.

3. Argo CD ensures drift is detected and managed.

4. You have traceability: commit → image tag → Git update → manifest change → Argo CD deploy.

5. Version control of both application code and infra code (via Terraform) plus manifests keeps everything auditable.
