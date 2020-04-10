pipeline {
    agent any

    stages {
        stage('Update Components') {
            steps {
                echo "Updating"
                sh "docker pull nginx:stable-alpine"
                sh "docker pull node:alpine"
            }
        }
        stage('Build') {
            steps {
                echo "Building"
                sh "docker build . --build-arg BUILD_ID=${env.BUILD_ID} --rm --pull"
            }
        }
        stage('Cleanup') {
            steps {
                echo "Cleaning Up"
                sh "docker image prune -f --filter label=stage=builder --filter label=build=${env.BUILD_ID} --filter label=item_name=website_public"
            }
        }
        stage('Upload') {
            steps {
                echo "Uploading"
                //UPLOAD TO RESGISTRY
            }
        }
        stage('Final Cleanup') {
            steps {
                echo "Performing Final Cleanup"
//                sh "docker image prune -f --filter label=stage=result --filter label=build=${env.BUILD_ID} --filter label=item_name=website_public"
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying"
                //SSH TO WEB DOCKER-COMPOSE DOWN, UPDATE AND UP
            }
        }
    }
    post {
        success {
            echo 'Very cash-money'
        }
        failure {
            echo 'That is not ideal'
        }
    }
}