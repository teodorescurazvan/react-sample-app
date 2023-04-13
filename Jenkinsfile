node {
    def app
    // clonam repository-ul
    stage('Cloning repository') {
        git credentialsId: 'github', url: 'https://github.com/teodorescurazvan/react-sample-app'
    }

    // Build Docker image
    stage('Build image') {
        app = docker.build("rteodore/react-sample-app", "Dockerfile.prod")
    } 

    // Push image to DockerHub
    stage('Push image on DockerHub') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    // Redeploy container
    stage('Redeploy container on latest image') {
        // Cleanup and respawn existing containers
        sh '''
            docker stop $(docker ps -aq))
            docker run -dit --name react-app-prod --rm -p 3002:3002 react-sample-app:latest'''
    }
}
