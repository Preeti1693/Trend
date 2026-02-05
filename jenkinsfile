pipeline {
  agent any

  environment {
    IMAGE_NAME = "trend-app"
    REGISTRY = "258215414348.dkr.ecr.ap-south-1.amazonaws.com"
    CLUSTER_NAME = "trend-eks"
    REGION = "ap-south-1"
  }

  stages {

    stage('Checkout') {
      steps {
        git url: '<your-repo-url>', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:latest .'
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY
        docker tag $IMAGE_NAME:latest $REGISTRY/$IMAGE_NAME:latest
        docker push $REGISTRY/$IMAGE_NAME:latest
        '''
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
        aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
        kubectl apply -f k8s/
        '''
      }
    }
  }
}

