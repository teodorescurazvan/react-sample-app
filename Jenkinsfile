node {
    def app
    // clonam repository-ul
    stage('Cloning repository') {
        git credentialsId: 'github', url: 'https://github.com/teodorescurazvan/react-sample-app'
    }

    // Build Docker image
    stage('Build image') {
        app = docker.build("rteodore/react-sample-app", "-f Dockerfile.prod .")
    } 

    // Push image to DockerHub
    stage('Push image on DockerHub') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    // Cleanup containers
    stage('Cleanup running containers') {
        sh '''docker stop $(docker ps -a -q)'''
    }

    // Respawn PROD container on locale react-sample-app PROD image
    stage ('Deploying latest image') {
        sh ''' docker run -d --name react-app-prod --rm -p 3002:80 react-sample-app:latest'''
    }
}
