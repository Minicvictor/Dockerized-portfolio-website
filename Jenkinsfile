pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Minicvictor/Dockerized-portfolio-website'
            }
        }

        stage('Build') {
            steps {
                echo 'Checking downloaded files'
                sh 'ls -la'
            }
        }

        stage('Deploy to Nginx') {
            steps {
                sh '''
                sudo rm -rf /var/www/html/*
                sudo cp -f index.html /var/www/html/index.html
                sudo systemctl restart nginx
                '''
            }
        }

        stage('Verify') {
            steps {
                sh 'curl -f http://localhost || exit 1'
            }
        }
    }

    post {
        success { echo 'Pipeline finished: SUCCESS - Site Deployed' }
        failure { echo 'Pipeline finished: FAILURE' }
    }
}
