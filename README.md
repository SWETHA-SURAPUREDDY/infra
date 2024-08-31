#### 1. Infrastructure as Code with Terraform
- **Why**: Infrastructure as Code (IaC) enables automated, consistent, and repeatable infrastructure management, which is essential for a continual delivery pipeline. Terraform ensures that infrastructure can be versioned, shared, and reused across environments.
- **How**:
  - **Resource Group**: Created a resource group in Azure to logically group all related resources.
  - **Virtual Network and Subnet**: Configured a virtual network and subnet for secure and isolated communication within the AKS cluster.
  - **Azure Container Registry (ACR)**: Deployed ACR to securely store and manage Docker images, utilizing integrated authentication and authorization mechanisms.
  - **AKS Cluster**: Deployed an Azure Kubernetes Service (AKS) cluster, the core infrastructure for deploying and managing containerized applications.

#### 2. Cost Optimization Approach
- **Why**: To minimize expenses while still meeting requirements, particularly since running separate clusters for test and production environments can be costly.
- **How**: 
  - **Shared AKS Cluster**: Used the same AKS cluster for both test and production environments, separating them logically by deploying the application into different namespaces (test and prod). This approach reduces costs while maintaining environment isolation.

#### 3. Continuous Delivery Pipeline with Azure Pipelines
- **Why**: The pipeline automates the build, test, and deployment processes, ensuring reliable and efficient delivery. Automation reduces manual errors and speeds up the delivery cycle.
- **How**:
  - **Pre-Deployment Validation**: Implemented a basic pre-deployment validation step using a bash script (`pre-deploy-validation.sh`) to ensure the environment is ready before deployment.
  - **Build Stage**: Configured the pipeline to build the application from source into a Docker image and push it to ACR.
  - **Deploy to Test Environment**: Deployed the application to the test namespace in the AKS cluster using Kubernetes manifests.
  - **Deploy to Production Environment**: Upon successful testing, the application is deployed to the production namespace.
  - **Post-Deployment Validation**: Conducted post-deployment checks using a bash script (`post-deploy-validation.sh`) to verify the success of the deployment.
