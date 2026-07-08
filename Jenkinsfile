pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy to Nginx') {
            steps {
                sh 'sudo rm -rf /var/www/html/*'
                sh 'sudo cp -r * /var/www/html/'
                sh 'sudo systemctl restart nginx'
            }
        }

        stage('Verify') {
            steps {
                sh 'curl -f http://localhost || exit 1'
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished: SUCCESS - Site deployed'
        }
        failure {
            echo 'Pipeline finished: FAILURE'
        }
    }
}
