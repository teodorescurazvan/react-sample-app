node {
    def app
    // clonam repository-ul
    stage('Cloning repository') {
        git credentialsId: 'github', url: 'https://github.com/teodorescurazvan/react-sample-app'
        }
    }

    // Build imaginea de Docker
    stage('Build image') {
        app = docker.build("rteodore/react-sample-app")
    } 

    // Push pe DockerHub
    stage('Push imagine pe DockerHub') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}