// Jenkins Declarative Pipeline for Windows CI/CD

pipeline {
    agent any

    // Define build parameters for user input
    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the target environment (dev or prod)')
        password(name: 'ADMIN_PASSWORD', description: 'Admin password for the new Virtual Machines (Required)')
        // AZURE_CREDENTIALS_ID is REMOVED as a parameter
    }

    // Define sensitive environment variables available throughout the pipeline
    environment {
        // TF_VAR_admin_password is the variable Terraform reads directly
        TF_VAR_admin_password = "${params.ADMIN_PASSWORD}"
        
        // These are the fixed IDs of the credentials stored in Jenkins
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_SECRET = credentials('AZURE_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Initialize & Authenticate') {
            steps {
                // We no longer need withCredentials because we loaded the credentials directly into the 'environment' block.

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
