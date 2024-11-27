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
                    // Verificar e instalar Docker y Buildx si es necesario
                    sh '''
                        # Verificar si Docker está instalado; si no, instalarlo
                        if ! command -v docker &> /dev/null; then
                            echo "Docker no encontrado, instalando..."
                            sudo apt-get update
                            sudo apt-get install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                        else
                            echo "Docker ya está instalado."
                        fi

                        # Verificar si Buildx está instalado; si no, instalarlo
                        if ! docker buildx version &> /dev/null; then
                            echo "Buildx no encontrado, instalando..."
                            sudo apt-get install -y docker-buildx-plugin
                        else
                            echo "Buildx ya está instalado."
                        fi
                    '''
                }
            }
        }
        stage('Clonar Repositorio') {
            steps {
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
                    sh '''
                        docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                    '''
                }
            }
        }
        stage('Subir Imagen a Docker Hub') {
            steps {
                script {
                    sh '''
                        docker buildx build --push --platform linux/amd64,linux/arm64 -t ${DOCKER_USER}/mi-imagen:latest .
                    '''
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}

