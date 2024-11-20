pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')

    }
   
   stages {
        stage('Checkout') {
            steps {
                git branch: 'iac', url: "https://github.com/Nishad89/terraform_nishad.git"
            }
        }
        stage('workspace') {
            steps {
                script {
                    sh "terraform workspace select dev || terraform workspace new dev"
                    sh 'terraform init'
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    input message: "Approve deployment to dev", ok: 'Approve'
                }
            }
        }
        stage('Dev') {
            steps {
                script {
                    ssh "terraform apply -var-file=environments/dev.tfvars -auto-approve"
                }
            }
        }
        //qa
        stage('workspace') {
            steps {
                script {
                    sh "terraform workspace select QA || terraform workspace new QA"
                    sh 'terraform init'
                }
            }
        }  
        stage('Approval') {
            steps {
                script {
                    input message: "Approve deployment to QA", ok: 'Approve'
                }
            }
        }
        stage('QA') {
            steps {
                script {
                    ssh "terraform apply -var-file=environments/qa.tfvars -auto-approve"
                }
            }
        }
    }
}




