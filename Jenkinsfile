pipeline {
    agent {
        docker {
            image 'node:alpine'
        }
    }
    stages {
        stage('Install dependencies') {
            steps {
                sh 'yarn install'  
            }
        }
        stage('Build') {
            steps {
                
                sh 'yarn build'
                sh 'docker build'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
            }
        }
    }
    post {
        success {
            echo 'Yay?'
        }
        failure {
            echo 'That is not ideal'
        }
    }
}