node {
    def app
    // clonam repository-ul
    stage('Cloning repository') {
        git credentialsId: 'github', url: 'https://github.com/teodorescurazvan/react-sample-app'
    }

    // Return current user
    /*stage('Return whoami') {
        step {
            sh '''#!/bin/bash
                echo $whoami
            '''
        }
    }*/

    // Build imaginea de Docker
    stage('Build image') {
        app = docker.build("react-sample-app")
    } 

    // Push pe DockerHub
    stage('Push imagine pe DockerHub') {
        docker.withRegistry('https://hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
