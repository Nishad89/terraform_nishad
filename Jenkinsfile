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
        stage('workspace_Dev') {
            steps {
                script {
                    sh "terraform workspace select dev || terraform workspace new dev"
                    sh 'terraform init'
                }
            }
        }
        stage(terraform_Plan){
            steps{
                script{
                sh 'terraform plan'
                }
            }
        }
        stage('Approval_Dev') {
            steps {
                script {
                    input message: "Approve deployment to dev", ok: 'Approve'
                }
            }
        }
        stage('Apply_Dev') {
            steps {
                script {
                    sh "terraform apply -var-file=environments/dev.tfvars -auto-approve"
                }
            }
        }
        //qa
        stage('workspace_QA') {
            steps {
                script {
                    sh "terraform workspace select QA || terraform workspace new QA"
                    sh 'terraform init'
                }
            }
        }  
        stage('Approval_QA') {
            steps {
                script {
                    input message: "Approve deployment to QA", ok: 'Approve'
                }
            }
        }
        stage('Apply_QA') {
            steps {
                script {
                    sh "terraform apply -var-file=environments/qa.tfvars -auto-approve"
                }
            }
        }
    }
}




