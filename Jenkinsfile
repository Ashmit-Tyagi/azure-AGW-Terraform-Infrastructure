// Jenkins Declarative Pipeline for Windows CI/CD

pipeline {
    agent any

    // Define build parameters for user input
    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the target environment (dev or prod)')
        password(name: 'ADMIN_PASSWORD', description: 'Admin password for the new Virtual Machines (Required)')
        // Use a generic placeholder ID that you map to your actual Client/Secret/Tenant credentials
        string(name: 'AZURE_CREDENTIALS_ID', description: 'Jenkins ID for Azure SP Credential Group (e.g., azure-sp-creds)')
    }

    // Define sensitive environment variables available throughout the pipeline
    environment {
        // TF_VAR_admin_password is the variable Terraform reads directly
        TF_VAR_admin_password = "${params.ADMIN_PASSWORD}"
    }

    stages {
        stage('Initialize & Authenticate') {
            steps {
                // Securely load the Azure Service Principal credentials
                withCredentials([
                    // IMPORTANT: You must map your Client ID, Secret, and Tenant ID to these specific IDs in Jenkins.
                    // The IDs below are placeholders showing the expected format.
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_SECRET", variable: 'AZURE_SECRET'),
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_ID", variable: 'AZURE_CLIENT_ID'),
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_TENANT", variable: 'AZURE_TENANT_ID')
                ]) {
                    // Use 'bat' for Windows shell commands
                    bat """
                        echo --- AZURE LOGIN ---
                        az login --service-principal ^
                            -u %AZURE_CLIENT_ID% ^
                            -p %AZURE_SECRET% ^
                            --tenant %AZURE_TENANT_ID%
                        
                        echo Setting subscription for context...
                        az account set --subscription 339e97cf-8522-4368-89b9-ca740955b522
                    """

                    // This initialization step must run before validation or plan
                    dir("environments/${params.ENV}") {
                        echo "--- INITIALIZING TERRAFORM for ${params.ENV} ---"
                        bat 'terraform init -upgrade -input=false' 
                    }
                }
            }
        }

        stage('Debug Repository Root') {
            steps {
                // FIX: Replaced complex 'dir /a' and 'dir environments/' with reliable Windows syntax.
                bat 'echo "--- Listing contents of the Jenkins Workspace Root: ---"'
                bat 'dir' 
                
                bat 'echo "--- Listing contents of environments/ directory: ---"'
                bat 'dir environments' // Simple syntax works best on Windows Batch
                bat 'echo "-----------------------------------------------------------------------------------"'
                
                // Now run validation after successful init
                dir("environments/${params.ENV}") {
                    echo "--- VALIDATING CONFIGURATION ---"
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENV}") {
                    echo "--- GENERATING PLAN ---"
                    // Pass the ADMIN_PASSWORD using the -var flag and the Windows variable syntax
                    bat 'terraform plan -var="admin_password=%TF_VAR_admin_password%" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Manual input prompt for safety before deploying to any environment
                input(message: "Approve deployment to ${params.ENV}?", ok: 'Proceed to Apply')
                
                dir("environments/${params.ENV}") {
                    echo "--- APPLYING CHANGES ---"
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo "Deployment Pipeline finished for environment ${params.ENV}."
            // Clean up the workspace
            cleanWs() 
        }
        failure {
            echo "Deployment failed! Check the logs above."
        }
    }
}
