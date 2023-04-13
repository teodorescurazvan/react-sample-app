node {
    def app
    stages {
        // clonam repository-ul
        stage('Cloning repository') {
            git credentialsId: 'github', url: 'https://github.com/teodorescurazvan/react-sample-app'
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

        // Redeploy container
        stage('Redeploy container on latest image') {
            steps {
                // Cleanup existing containers
                sh 'docker rm $(docker ps --filter status=exited -q)'
                // Recreate container with latest image
                sh 'docker run -dit --name react-app-prod --rm -p 3002:80 react-sample-app:latest' 
            }    
        }
    }    
}
