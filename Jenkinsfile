pipeline {
    agent any

    environment {
        IMAGE_NAME = "jaysoft007/my-app"
        TAG = "latest"
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/jaysofty/my-app.git'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Scan Image (Trivy)') {
            steps {
        sh '''pipeline {
    agent any

    environment {
        IMAGE_NAME = "jaysoft007/my-app"
        TAG = "${BUILD_NUMBER}"
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/jaysofty/my-app.git'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Scan Image (Trivy)') {
            steps {
                sh '''
                trivy image \
                  --exit-code 1 \
                  --severity HIGH,CRITICAL \
                  --format template \
                  --template "@html.tpl" \
                  -o trivy-report.html \
                  $IMAGE_NAME:$TAG
                '''
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh '''
                echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$TAG'
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                sh '''
                docker stop my-app || true
                docker rm my-app || true

                docker run -d -p 8081:80 \
                  --name my-app \
                  $IMAGE_NAME:$TAG
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful"
        }
        failure {
            echo "❌ Build Failed"
        }
    }
}
        trivy image \
          --format template \
          --template "@html.tpl" \
          -o trivy-report.html \
          $IMAGE_NAME:$TAG
        '''
        }
}

        stage('Login to DockerHub') {
            steps {
                sh '''
                echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$TAG'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop my-app || true
                docker rm my-app || true

                docker run -d -p 8081:80 \
                  --name my-app \
                  $IMAGE_NAME:$TAG
                '''
            }
        }
    }
    post {
        success {
            echo "🚀 Deployment Successful"
        }
        failure {
            echo "❌ Build Failed"
        }
    }
}