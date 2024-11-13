pipeline {

    parameters{
       choice(name: 'ENVIRONMENT', choices: ['dev', 'qa'], description: 'Select environment to deploy')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')

    }
   
   agent  any
    stages {
        stage('checkout') {
            steps {
                        {
                            git branch: 'iac', url: "https://github.com/Nishad89/terraform_nishad.git"
                        }
                    }
                }
            }
        stage('Show Environment') {
            steps {
                script {
                    echo "Deploying to environment: ${params.ENVIRONMENT}"
                }
            }
        }

        stage('Init') {
            steps {
                script {
                    // Select or create the workspace for the selected environment
                    sh "terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}"
                    // Initialize Terraform with the appropriate backend
                    sh "terraform init -backend-config='key=terraform/${params.ENVIRONMENT}/terraform.tfstate'"
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                    // Run terraform plan using the environment-specific variables
                    sh "terraform plan -var-file=environments/${params.ENVIRONMENT}/workspace.tfvars"
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    // Manual approval stage
                    input message: "Approve deployment to ${params.ENVIRONMENT}?", ok: 'Approve'
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    // Apply the Terraform configuration
                    sh "terraform apply -var-file=environments/${params.ENVIRONMENT}/workspace.tfvars -auto-approve"
                }
            }
        }
    }
}