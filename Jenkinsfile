pipeline {
    agent {
    dockerfile {
        label 'website_public-page'
//        additionalBuildArgs  '--build-arg version=1.0.2'
        args '-v /tmp:/tmp'
    }
}
    stages {
        stage('Build') {
            steps {
                sh 'docker build --build-arg BUILD_ID=${env.BUILD_ID}'
                sh 'docker image prune --filter label=stage=builder --filter label=build=${env.BUILD_ID}'
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