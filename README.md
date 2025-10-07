# Azure-AGW-Terraform-Infrastructure


## This project uses Terraform to provision and manage a secure, web application on Azure. The application is a simple NGINX server running within a Docker container. All infrastructure is defined as code, enabling repeatable and consistent deployments.

## Prerequisites

    - Terraform CLI: Download and install the latest version.

    - Azure CLI: Download and install the Azure command-line tool.

    - Git: To clone the repository.
    
### Also be authenticated to your Azure account. Open your terminal and run az login to perform an interactive login and set your default subscription.


## Repository Structure

### The project uses a standard and scalable repository structure to support different environments (dev, prod) and reusable infrastructure modules.

<img width="441" height="349" alt="Screenshot 2025-10-07 165409" src="https://github.com/user-attachments/assets/c8ac58fe-84df-4d53-bd02-3b24858af531" />


### The Terraform configuration in this project serves as a blueprint for an entire web application stack. It automatically provisions the following key components in Azure:

    - Resource Group: A logical container to hold all the infrastructure resources.

    -  Virtual Network: A private network to host the application.

    - Two Subnets: A public subnet for the Application Gateway and a private subnet for the Virtual Machines.

    - Network Security Group (NSG): A virtual firewall to secure traffic to the VMs.

    - Two Virtual Machines: Ubuntu servers that will host the web applications.

    - Application Gateway: An application load balancer with a public IP that routes traffic based on URL paths.

    - Backend Pools: Two distinct pools, each containing the private IP of one of the VMs


  <img width="1915" height="1196" alt="Screenshot 2025-10-07 170317" src="https://github.com/user-attachments/assets/6ffc4ddf-d99b-4c90-8e7e-84357080ed08" />


## CI/CD Automation with Jenkins

### This project includes a Jenkinsfile for automated, multi-environment deployments. The pipeline is designed to be fully automated and follows secure practices.

#### 1. Parameters: The Jenkins job accepts env as a parameter to deploy to dev or prod. The admin_password is provided as a secure input at runtime.

#### 2. Secure Authentication: The pipeline uses an Azure Service Principal for non-interactive login. The Jenkinsfile uses the withCredentials block to securely inject the clientId, clientSecret, and tenantId into the build environment.

#### 3. Execution Flow: The pipeline executes the init, plan, and apply commands in sequence, ensuring a consistent and reliable deployment every time.

#### 4. Multi-Environment Support: The Jenkinsfile dynamically navigates to the correct environments/<env> directory based on the user's input, allowing the same pipeline to deploy to different environments.

<img width="1919" height="1052" alt="Screenshot 2025-10-07 200315" src="https://github.com/user-attachments/assets/00a82eb4-34c7-45cb-9d57-49b44fb4d123" />


<img width="1919" height="1199" alt="Screenshot 2025-10-07 200124" src="https://github.com/user-attachments/assets/f64c7654-21e9-49b5-97a4-97b54ecb66e2" />

## Test

### Using the gateway’s public IP 

<img width="1917" height="1199" alt="Screenshot 2025-10-07 170332" src="https://github.com/user-attachments/assets/50e12517-7be1-495d-8dfa-14b70bf44d95" />


<img width="1918" height="1199" alt="Screenshot 2025-10-07 170245" src="https://github.com/user-attachments/assets/ad5e51d8-45b3-4df1-9609-8258db879153" />



