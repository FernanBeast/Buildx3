pipeline {
    agent any
    environment {
        DOCKER_USER = 'fernanbeast'  // Tu nombre de usuario de Docker Hub
        DOCKER_BUILDX = 'mybuilder'  // Nombre del builder de Buildx
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                // Clonando el repositorio de GitHub, usando credenciales si es privado
                git branch: 'main', url: 'https://github.com/FernanBeast/Buildx3.git', credentialsId: 'github-credentials-id'
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
