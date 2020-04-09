pipeline {
  agent any
  stages {
    stage('Begin') {
      steps {
        echo 'Starting build'
        sh '''git clone https://github.com/YSTV/Website2ElectricBoogaloo.git
cd Website2ElectricBoogaloo'''
      }
    }

    stage('Build') {
      steps {
        echo 'Downloaded, starting build'
        sh 'docker-compose up -d --build --force-recreate --remove-orphans --build-arg BUILD_ID'
        echo 'Finished build and running'
      }
    }

    stage('Clean Up & Deploy') {
      steps {
        echo 'Cleaning up'
        sh 'docker image prune --filter label=stage=builder --filter label=build=$BUILD_ID'
      }
    }

  }
}