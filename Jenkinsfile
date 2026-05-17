pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-jenkins-app"
        DOCKERHUB_USER = "jaysoft007"
    }

    triggers {
        githubPush()
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/jaysofty/my-docker-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t $IMAGE_NAME:${BUILD_NUMBER} .
                """
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh """
                trivy image $IMAGE_NAME:${BUILD_NUMBER}
                """
            }
        }

        stage('Run Container Test') {
            steps {
                sh """
                docker run -d --name test-app -p 8081:80 $IMAGE_NAME:${BUILD_NUMBER}
                sleep 5
                docker ps
                docker stop test-app
                docker rm test-app
                """
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                sh """
                docker tag $IMAGE_NAME:${BUILD_NUMBER} $DOCKERHUB_USER/$IMAGE_NAME:${BUILD_NUMBER}
                docker push $DOCKERHUB_USER/$IMAGE_NAME:${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        always {
            sh """
            docker system prune -f || true
            """
        }
    }
}