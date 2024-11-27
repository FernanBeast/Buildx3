pipeline {
    agent any
    environment {
        DOCKER_USER = 'fernanbeast'  // Your Docker Hub username
        DOCKER_BUILDX = 'docker-buildx-builder'  // Name of the Buildx builder
        SONARQUBE = 'SonarQubeLocal'  // Name of the SonarQube server configured in Jenkins
        SONARQUBE_TOKEN = credentials('sonarqube-token-id')  // SonarQube token for authentication
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                // Cloning the repository from GitHub using credentials if private
                git branch: 'main', url: 'https://github.com/FernanBeast/Buildx3.git', credentialsId: 'github-credentials-id'
            }
        }
        stage('SonarQube Análisis') {
            steps {
                script {
                    // Configure and run SonarQube analysis
                    def scannerHome = tool 'SonarQube Scanner'  // The name of the scanner configured in Jenkins
                    withSonarQubeEnv(SONARQUBE) {  // Use the SonarQube configuration set in Jenkins
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=mi-proyecto \
                                -Dsonar.sources=src \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.login=${SONARQUBE_TOKEN}  // Authentication token
                        """
                    }
                }
            }
        }
        stage('Configurar Docker Buildx') {
            steps {
                script {
                    // Create a Buildx builder if it doesn't exist and configure it for use
                    sh '''
                        docker buildx ls | grep -q ${DOCKER_BUILDX} || docker buildx create --name ${DOCKER_BUILDX} --use
                    '''
                }
            }
        }
        stage('Construir Imagen Docker usando Buildx') {
            steps {
                script {
                    // Build the Docker image using Buildx
                    sh '''
                        docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                    '''
                }
            }
        }
        stage('Subir Imagen a Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the image using Buildx
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
                            docker buildx build --push --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up workspace after the pipeline finishes
            cleanWs()
        }
    }
}
