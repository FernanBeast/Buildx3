pipeline {
    agent any
    environment {
        DOCKER_USER = 'miusuario'  // Asegúrate de que el nombre de usuario de Docker Hub esté aquí
    }
    stages {
        stage('Clonar Repositorio') {
            steps {
                // Clonando el repositorio de GitHub, usando credenciales si es privado
                git branch: 'main', url: 'https://github.com/FernanBeast/Buildx3.git', credentialsId: 'github-credentials-id'
            }
        }
        stage('Construir Imagen Docker') {
            steps {
                script {
                    // Construir la imagen Docker
                    docker.build("${DOCKER_USER}/mi-imagen")
                }
            }
        }
        stage('Subir Imagen a Docker Hub') {
            steps {
                script {
                    // Subir la imagen a Docker Hub usando las credenciales configuradas
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials2') {
                        docker.image("${DOCKER_USER}/mi-imagen").push('latest')
                    }
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
