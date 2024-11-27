pipeline {
    agent any
    environment {
        DOCKER_USER = 'fernanbeast'  // Tu nombre de usuario de Docker Hub
        DOCKER_BUILDX = 'docker-buildx-builder'  // Nombre del builder de Buildx
        SONARQUBE = 'SonarQubeLocal'  // Nombre del servidor de SonarQube configurado en Jenkins
        SONARQUBE_TOKEN = credentials('sonar-token')  // Credenciales de SonarQube (token de autenticación)
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                // Clonando el repositorio de GitHub, usando credenciales si es privado
                git branch: 'main', url: 'https://github.com/FernanBeast/Buildx3.git', credentialsId: 'github-credentials-id'
            }
        }
        stage('SonarQube Análisis') {
            steps {
                script {
                    // Configurar y ejecutar el análisis de SonarQube
                    def scannerHome = tool 'SonarQube Scanner'  // Este es el nombre del scanner configurado en Jenkins
                    withSonarQubeEnv(SONARQUBE) {  // Usa la configuración de SonarQube que has establecido en Jenkins
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=mi-proyecto \
                                -Dsonar.sources=src \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.login=${SONARQUBE_TOKEN}  // Si necesitas token de autenticación
                        """
                    }
                }
            }
        }
        stage('Configurar Docker Buildx') {
            steps {
                script {
                    // Crear un builder si no existe, y configurarlo para usarlo
                    sh '''
                        # Verifica si el builder ya está creado, si no lo crea
                        docker buildx ls | grep -q ${DOCKER_BUILDX} || docker buildx create --name ${DOCKER_BUILDX} --use
                    '''
                }
            }
        }
        stage('Construir Imagen Docker usando Buildx') {
            steps {
                script {
                    // Construir la imagen Docker usando Buildx
                    sh '''
                        docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                    '''
                }
            }
        }
        stage('Subir Imagen a Docker Hub') {
            steps {
                script {
                    // Subir la imagen a Docker Hub usando Buildx
                    sh '''
                        docker buildx build --push --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                    '''
                }
            }
        }
    }
    post {
        always {
            // Limpiar el espacio de trabajo al final del pipeline
            cleanWs()
        }
    }
}
