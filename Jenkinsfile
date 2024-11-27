pipeline {
    agent any
    environment {
        DOCKER_USER = 'fernanbeast'  // Tu nombre de usuario de Docker Hub
        DOCKER_BUILDX = 'docker-buildx-builder'  // Nombre del builder de Buildx
    }
    stages {
        stage('Preparar Entorno') {
            steps {
                script {
                    // Instalar curl, Docker y configurar Buildx
                    sh '''
                        # Verificar si curl está instalado; si no, instalarlo
                        if ! command -v curl &> /dev/null; then
                            echo "curl no encontrado, instalando..."
                            sudo apt-get update
                            sudo apt-get install -y curl
                        else
                            echo "curl ya está instalado."
                        fi
                        
                        # Verificar si Docker está instalado; si no, instalarlo
                        if ! command -v docker &> /dev/null; then
                            echo "Docker no encontrado, instalando..."
                            sudo apt-get install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                        else
                            echo "Docker ya está instalado."
                        fi
                        
                        # Verificar si Buildx está configurado; si no, configurarlo
                        if ! docker buildx version &> /dev/null; then
                            echo "Buildx no encontrado, configurando..."
                            docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
                            mkdir -p ~/.docker/cli-plugins
                            curl -SL https://github.com/docker/buildx/releases/latest/download/docker-buildx-linux-amd64 -o ~/.docker/cli-plugins/docker-buildx
                            chmod +x ~/.docker/cli-plugins/docker-buildx
                        else
                            echo "Buildx ya está configurado."
                        fi
                    '''
                }
            }
        }
        stage('Clonar Repositorio') {
            steps {
                // Clonar el repositorio de GitHub, usando credenciales si es privado
                git branch: 'main', url: 'https://github.com/FernanBeast/Buildx3.git', credentialsId: 'github-credentials-id'
            }
        }
        stage('Configurar Docker Buildx') {
            steps {
                script {
                    // Crear un builder si no existe, y configurarlo para usarlo
                    sh '''
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
