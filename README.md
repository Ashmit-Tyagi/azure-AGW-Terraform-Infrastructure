# Azure-AGW-Terraform-Infrastructure


## This project uses Terraform to provision and manage a secure, web application on Azure. The application is a simple NGINX server running within a Docker container. All infrastructure is defined as code, enabling repeatable and consistent deployments.

## Repository Structure

### The project uses a standard and scalable repository structure to support different environments (dev, prod) and reusable infrastructure modules.

<img width="441" height="349" alt="Screenshot 2025-10-07 165409" src="https://github.com/user-attachments/assets/c8ac58fe-84df-4d53-bd02-3b24858af531" />

## Prerequisites

    - Terraform CLI: Download and install the latest version.

    - Azure CLI: Download and install the Azure command-line tool.

    - Git: To clone the repository.

### Also be authenticated to your Azure account. Open your terminal and run az login to perform an interactive login and set your default subscription.


## CI/CD Automation with Jenkins

### This project includes a Jenkinsfile for automated, multi-environment deployments. The pipeline is designed to be fully automated and follows secure practices.

#### 1. Parameters: The Jenkins job accepts env as a parameter to deploy to dev or prod. The admin_password is provided as a secure input at runtime.

#### 2. Secure Authentication: The pipeline uses an Azure Service Principal for non-interactive login. The Jenkinsfile uses the withCredentials block to securely inject the clientId, clientSecret, and tenantId into the build environment.

#### 3. Execution Flow: The pipeline executes the init, plan, and apply commands in sequence, ensuring a consistent and reliable deployment every time.

#### 4. Multi-Environment Support: The Jenkinsfile dynamically navigates to the correct environments/<env> directory based on the user's input, allowing the same pipeline to deploy to different environments.
