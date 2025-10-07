// Jenkins Declarative Pipeline for Windows CI/CD

pipeline {
    agent any

    environment {
        // AZURE_CREDENTIALS is expected to be a Secret Text or File containing the SP JSON
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS') 
        
        // TF_VAR_admin_password is expected to be a Password credential ID
        // Note: For bat/powershell commands, this variable will be accessed as %ADMIN_PASS% inside the script block
        TF_VAR_admin_password = credentials('TF_VAR_admin_password')
    }

    stages {
        // The previous 'Checkout' stage is handled by the pipeline definition.

        stage('Azure Login') {
            steps {
                // The 'withCredentials' block is necessary to expose the credential content 
                withCredentials([
                    // Binding the secret content to a variable named AZURE_SP_JSON
                    string(credentialsId: 'AZURE_CREDENTIALS', variable: 'AZURE_SP_JSON'),
                    // Binding the password content to a variable named ADMIN_PASS
                    string(credentialsId: 'TF_VAR_admin_password', variable: 'ADMIN_PASS')
                ]) {
                    script {
                        // FIX: readJSON is a Groovy step, so it stays.
                        def creds = readJSON text: AZURE_SP_JSON
                        
                        // FIX: Replaced 'sh' with 'bat' for Windows execution.
                        // FIX: Used Groovy interpolation (${...}) to insert JSON values into the command.
                        bat """
                            echo --- AZURE LOGIN ---
                            az login --service-principal ^
                                -u ${creds.clientId} ^
                                -p ${creds.clientSecret} ^
                                --tenant ${creds.tenantId}
                            
                            az account set --subscription ${creds.subscriptionId}
                        """
                        // We must expose the password explicitly as an environment variable for later stages
                        env.TF_VAR_admin_password = ADMIN_PASS
                    }
                }
            }
        }

        stage('Debug Repository Root') {
            steps {
                // FIX: Replaced 'sh' with 'bat' and 'ls -l' with 'dir'
                bat 'echo "--- Listing contents of the Jenkins Workspace Root: ---"'
                bat 'dir'
                
                bat 'echo "--- Listing contents of environments/ directory: ---"'
                bat 'dir environments'
                bat 'echo "-----------------------------------------------------------------------------------"'
            }
        }

        stage('Terraform Init and Plan') {
            steps {
                dir('environments/dev') {
                    // FIX: Replaced 'sh' with 'bat'
                    bat 'terraform init -upgrade'
                    // FIX: Replaced $TF_VAR_admin_password with %TF_VAR_admin_password% (Windows syntax)
                    bat 'terraform plan -var="admin_password=%TF_VAR_admin_password%" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_CHANGES == true }
            }
            steps {
                dir('environments/dev') {
                    // FIX: Replaced 'sh' with 'bat'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes automatically')
    }

    post {
        always {
            cleanWs()
        }
    }
}
