pipeline {
    agent any
    stages {
        stage('Clonar Repositorio') {
            steps {
                git 'https://github.com/FernanBeast/Buildx3.git'
            }
        }
        stage('Construir Imagen Docker') {
            steps {
                script {
                    docker.build('miusuario/mi-imagen')
                }
            }
        }
        stage('Subir Imagen a Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials2') {
                        docker.image('miusuario/mi-imagen').push('latest')
                    }
                }
            }
        }
    }
}
