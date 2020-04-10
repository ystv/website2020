pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh "docker build . --build-arg BUILD_ID=${env.BUILD_ID}"
                sh "docker image ls"
                sh "docker image prune --filter label=stage=builder --filter label=build=${env.BUILD_ID} --filter label=item_name=website_public -y"
                sh "docker image ls"
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