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
        sh '''docker kill $(docker ps -q)'''
        sh '''docker rm $(docker ps -a -q)'''
    }

    // Respawn PROD container on locale react-sample-app PROD image
    stage ('Deploy latest image') {
        sh '''docker run -d -p 3002:80 rteodore/react-sample-app:latest'''
    }
}
