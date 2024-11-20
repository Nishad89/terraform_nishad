pipeline {
    agent any
    // parameters{
    //    choice(name: 'ENVIRONMENT', choices: ['dev', 'qa'], description: 'Select environment to deploy')
    // }
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
                    echo "Deploying to environment: dev "
                }
            }
        }

        stage('workspace') {
            steps {
                script {
                    // Select or create the workspace for the selected environment
                    sh "terraform workspace select dev || terraform workspace new dev"
                    sh 'terraform init'
                    // Initialize Terraform with the appropriate backend
                }
            }
        }
           stage('Plan') {
            steps {
                script {
                    // Run terraform plan using the environment-specific variables
                    sh "terraform plan -var-file=environments/dev.tfvars"
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    // Manual approval stage
                    input message: "Approve deployment to dev?", ok: 'Approve'
                }
            }
        }

        stage('Dev') {
            steps {
                script {
                    // Apply the Terraform configuration
                    sh "terraform apply -var-file=environments/dev.tfvars -auto-approve"
                }
            }
        }
    }

//QA
      stage('Show Environment') {
            steps {
                script {
                    echo "Deploying to environment: QA "
                }
            }
        }

        stage('workspace') {
            steps {
                script {
                    // Select or create the workspace for the selected environment
                    sh "terraform workspace select qa || terraform workspace new qa"
                    sh 'terraform init'
                    // Initialize Terraform with the appropriate backend
                }
            }
        }
           stage('Plan') {
            steps {
                script {
                    // Run terraform plan using the environment-specific variables
                    sh "terraform plan -var-file=environments/qa.tfvars"
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    // Manual approval stage
                    input message: "Approve deployment to qa?", ok: 'Approve'
                }
            }
        }

        stage('QA') {
            steps {
                script {
                    // Apply the Terraform configuration
                    sh "terraform apply -var-file=environments/qa.tfvars -auto-approve"
                }
            }
        }
    }




