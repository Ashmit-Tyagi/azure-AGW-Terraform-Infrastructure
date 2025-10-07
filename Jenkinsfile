
pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the target environment (dev or prod)')
        password(name: 'ADMIN_PASSWORD', description: 'Admin password for the new Virtual Machines (Required)')
        string(name: 'AZURE_CREDENTIALS_ID', description: 'Jenkins ID for Azure SP Credential Group (e.g., azure-sp-creds)')
    }

    environment {
        TF_VAR_admin_password = "${params.ADMIN_PASSWORD}"
    }

    stages {
        stage('Initialize & Authenticate') {
            steps {
                withCredentials([
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_SECRET", variable: 'AZURE_SECRET'),
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_ID", variable: 'AZURE_CLIENT_ID'),
                    string(credentialsId: "${params.AZURE_CREDENTIALS_ID}_TENANT', variable: 'AZURE_TENANT_ID')
                ]) {
                    bat """
                        echo --- AZURE LOGIN ---
                        az login --service-principal ^
                            -u %AZURE_CLIENT_ID% ^
                            -p %AZURE_SECRET% ^
                            --tenant %AZURE_TENANT_ID%
                        
                        echo Setting subscription for context...
                        az account set --subscription 339e97cf-8522-4368-89b9-ca740955b522
                    """

                    dir("environments/${params.ENV}") {
                        echo "--- INITIALIZING TERRAFORM for ${params.ENV} ---"
                        bat 'terraform init -upgrade -input=false' 

                        echo "--- VALIDATING CONFIGURATION ---"
                        bat 'terraform validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENV}") {
                    echo "--- GENERATING PLAN ---"
                    bat 'terraform plan -var="admin_password=%TF_VAR_admin_password%" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
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
            cleanWs() 
        }
        failure {
            echo "Deployment failed! Check the logs above."
        }
    }
}
