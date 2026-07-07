pipeline {
    agent any

    environment {
        IMAGE_NAME = "minicvictor-portfolio"
        CONTAINER_NAME = "portfolio-site"
        PORT = "8081"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Minicvictor/Dockerized-portfolio-website.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'No npm install needed - site is static HTML. Skipping.'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Docker Image'
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Test') { // Extra credit
            steps {
                echo 'Running container health check'
                sh 'docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME'
                sh 'sleep 5'
                sh 'curl -f http://localhost:$PORT || exit 1'
            }
        }

        stage('Run Application') {
            steps {
                echo 'Deploying Application'
                sh 'docker stop $CONTAINER_NAME || true'
                sh 'docker rm $CONTAINER_NAME || true'
                sh 'docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME'
            }
        }

        stage('Cleanup') { // Extra credit
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        success {
            echo "Pipeline Finished: SUCCESS - App running on http://localhost:8081"
        }
        failure {
            echo 'Pipeline Failed'
            sh 'docker stop $CONTAINER_NAME || true'
            sh 'docker rm $CONTAINER_NAME || true'
        }
    }
}
