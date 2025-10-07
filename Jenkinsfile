// Jenkins Declarative Pipeline for Windows CI/CD

pipeline {
    agent any

    environment {
        // AZURE_CREDENTIALS is expected to be a Secret File or Secret Text credential ID 
        // We will read the AZURE SP JSON directly from the file/text content in the script stage.
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS') 
        
        // TF_VAR_admin_password is expected to be a Password credential ID
        TF_VAR_admin_password = credentials('TF_VAR_admin_password')
    }

    stages {
        stage('Azure Login') {
            steps {
                // Use a standard withCredentials binding to expose the credential content
                // to a temporary file/variable which the script can read.
                // NOTE: This assumes the 'AZURE_CREDENTIALS' is stored as a SECRET TEXT 
                // in Jenkins containing the Azure SP JSON data.
                withCredentials([
                    string(credentialsId: 'AZURE_CREDENTIALS', variable: 'AZURE_SP_JSON'),
                    string(credentialsId: 'TF_VAR_admin_password', variable: 'ADMIN_PASS')
                ]) {
                    script {
                        // The temporary JSON content is available in the AZURE_SP_JSON variable.
                        // We must parse it using a Groovy step, as batch/powershell parsing is complex.
                        // This requires the 'Pipeline Utility Steps' plugin for readJSON.
                        def creds = readJSON text: AZURE_SP_JSON 
                        
                        // Using a Groovy/shell execution block for clean formatting of the command.
                        // All 'sh' are replaced with 'bat' commands.
                        bat """
                            az login --service-principal ^
                                -u ${creds.clientId} ^
                                -p ${creds.clientSecret} ^
                                --tenant ${creds.tenantId}
                            
                            az account set --subscription ${creds.subscriptionId}
                        """
                    }
                }
            }
        }

        stage('Debug Repository Root') {
            steps {
                // Using 'dir' and 'bat' commands for directory listing on Windows
                bat 'echo "--- Listing contents of the Jenkins Workspace Root (where environments/ is): ---"'
                bat 'dir /a' // 'dir' is the Windows equivalent of 'ls -l'
                bat 'echo "--- Listing contents of environments/ directory: ---"'
                bat 'dir environments/'
                bat 'echo "-----------------------------------------------------------------------------------"'
            }
        }

        stage('Terraform Init and Plan') {
            steps {
                dir('environments/dev') {
                    // Using 'bat' for Terraform commands
                    bat 'terraform init -upgrade' 
                    // Use %TF_VAR_admin_password% which is set as a global environment variable
                    bat 'terraform plan -var="admin_password=%ADMIN_PASS%" -out=tfplan' 
                }
            }
        }

        stage('Terraform Apply') {
            when {
                // Note: The 'params' variable is global and accessible.
                expression { return params.APPLY_CHANGES == true }
            }
            steps {
                dir('environments/dev') {
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
