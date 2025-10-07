pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS') 
    
        TF_VAR_admin_password = credentials('TF_VAR_admin_password')
    }

    stages {

        stage('Azure Login') {
            steps {
                withCredentials([
                    string(credentialsId: 'AZURE_CREDENTIALS', variable: 'AZURE_SP_JSON'),
                    string(credentialsId: 'TF_VAR_admin_password', variable: 'ADMIN_PASS')
                ]) {
                    script {
                        def creds = readJSON text: AZURE_SP_JSON
                        
                        bat """
                            echo --- AZURE LOGIN ---
                            az login --service-principal ^
                                -u ${creds.clientId} ^
                                -p ${creds.clientSecret} ^
                                --tenant ${creds.tenantId}
                            
                            az account set --subscription ${creds.subscriptionId}
                        """
                        env.TF_VAR_admin_password = ADMIN_PASS
                    }
                }
            }
        }

        stage('Terraform Init and Plan') {
            steps {
                dir('environments/dev') {
                    bat 'terraform init -upgrade'
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
