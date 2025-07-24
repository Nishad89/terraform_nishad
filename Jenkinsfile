pipeline {
  agent any

  environment {
    AWS_ACCOUNT_ID = '586394722458'              // your AWS account
    AWS_REGION = 'us-east-1'                      // your AWS region
    ECR_REPO = 'demo-java-app'                    // your ECR repo name
    IMAGE_TAG = "${env.BUILD_NUMBER}"             // image tag = build number
    ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    CLUSTER_NAME = 'demo-cluster'
    SERVICE_NAME = 'demo-service'
    TASK_FAMILY = 'demo-task'
  }

  stages {
    stages {
        stage('Checkout') {
            steps {
                
                git branch: 'java-ecs', url: "https://github.com/Nishad89/terraform_nishad.git"
                }
             }

    stage('Build Java App') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Login to ECR') {
      steps {
        script {
          sh """
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
          """
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          sh """
          docker build -t ${ECR_REPO}:${IMAGE_TAG} .
          docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
          docker push ${ECR_URI}:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Update ECS Task Definition & Service') {
      steps {
        script {
          // Get current task definition JSON
          def taskDefJson = sh(
            script: "aws ecs describe-task-definition --task-definition ${TASK_FAMILY}",
            returnStdout: true
          )
          def taskDef = readJSON text: taskDefJson

          // Modify the container image to new image URI
          taskDef.taskDefinition.containerDefinitions[0].image = "${ECR_URI}:${IMAGE_TAG}"

          // Remove fields that can't be registered
          taskDef.taskDefinition.remove('revision')
          taskDef.taskDefinition.remove('status')
          taskDef.taskDefinition.remove('taskDefinitionArn')
          taskDef.taskDefinition.remove('requiresAttributes')
          taskDef.taskDefinition.remove('compatibilities')
          taskDef.taskDefinition.remove('registeredAt')
          taskDef.taskDefinition.remove('registeredBy')

          // Save updated JSON to a file
          writeJSON file: 'updated-task-def.json', json: taskDef.taskDefinition

          // Register new task definition revision
          sh """
          aws ecs register-task-definition --cli-input-json file://updated-task-def.json
          """

          // Update ECS service to use new task definition revision
          def newTaskDefArn = sh(
            script: "aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --query 'taskDefinition.taskDefinitionArn' --output text",
            returnStdout: true
          ).trim()

          sh """
          aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${newTaskDefArn}
          """
        }
      }
    }
  }

  post {
    failure {
      echo 'Build or deploy failed!'
    }
    success {
      echo 'Deployed successfully to ECS!'
    }
  }
}
