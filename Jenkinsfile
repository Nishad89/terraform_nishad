pipeline {
    agent any
    parameters{
       choice(name: 'ENVIRONMENT', choices: ['dev', 'qa'], description: 'Select environment to deploy')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')

    }
   
   stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository
                git branch: 'iac', url: "https://github.com/Nishad89/terraform_nishad.git"
            }
        }
        stage('Show Environment') {
            steps {
                script {
                    echo "Deploying to environment: ${params.ENVIRONMENT}"
                }
            }
        }

        stage('workspace') {
            steps {
                script {
                    // Select or create the workspace for the selected environment
                    sh "terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}"
                    sh "terraform init"
                    // Initialize Terraform with the appropriate backend
                }
            }
        }

   }
}