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
                sh "docker build . --build-arg BUILD_ID=${env.BUILD_ID} --rm --pull -t ystv/public-website:latest"
            }
        }
        stage('Cleanup') {
            steps {
                echo "Cleaning Up"
                sh "docker image prune -f --filter label=stage=builder --filter label=build=${env.BUILD_ID} --filter label=item_name=website-public"
            }
        }
        stage('Upload') {
            steps {
                sh "docker tag ystv/public-website localhost:5000/ystv/public-website:${env.BUILD_ID}" // Targeting
                sh "docker push localhost:5000/ystv/public-website:${env.BUILD_ID}" // Uploaded to registry
            }
        }
        stage('Final Cleanup') {
            steps {
                echo "Performing Final Cleanup"
                sh "docker rmi -f ystv/public-website" // Removing the local image
//                sh "docker image prune -f --filter label=stage=result --filter label=build=${env.BUILD_ID} --filter label=item_name=website_public"
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying"
                sh "docker pull localhost:5000/ystv/public-website:${env.BUILD_ID}" // Pulling image from local registry
                sh "docker run -d --rm -p 1337:80 --name ystv-dev-site localhost:5000/ystv-public-site:${env.BUILD_ID}" // Deploying site
                // Just doing it locally for the time-being, a cheeky web-hook might be an alternative?
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