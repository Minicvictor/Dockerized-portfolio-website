pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repo...'
                git branch: 'main',
                    url: 'https://github.com/Minicvictor/Dockerized-portfolio-website'
            }
        }

        stage('Build') {
            steps {
                echo 'Checking downloaded files'
                sh 'ls -la'
                sh 'ls -la html'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Dependencies step completed: Nginx already installed'
            }
        }

        stage('Run Application') {
            steps {
                echo 'Deploying to Nginx...'
                sh '''
                    sudo cp -r html/* /var/www/html/
                    sudo systemctl restart nginx
                '''
            }
        }

    }

    post {
        success {
            echo 'Pipeline Finished: SUCCESS - Site deployed to http://localhost'
        }
        failure {
            echo 'Pipeline Finished: FAILURE'
        }
    }
}
