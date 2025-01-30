pipeline {
    agent any
    environment {
        IMAGE_NAME = 'alpinehelloworld'
        IMAGE_TAG = 'latest'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/mandson/alpinehelloworld.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    if (!env.IMAGE_NAME || !env.IMAGE_TAG) {
                        error "Error: IMAGE_NAME or IMAGE_TAG is not set."
                    }
                    sh """
                        if docker ps -a --filter "name=${IMAGE_NAME}" | grep ${IMAGE_NAME}; then
                            echo "Removing existing container ${IMAGE_NAME}..."
                            docker stop ${IMAGE_NAME} && docker rm ${IMAGE_NAME}
                        fi

                        echo "Building Docker image..."
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                sh """
                    echo "Running Docker container..."
                    docker run -d -p 80:5000 -e PORT=5000 --rm --name ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5

                    if ! docker ps --filter "name=${IMAGE_NAME}" | grep ${IMAGE_NAME}; then
                        echo "Error: Failed to start the container."
                        exit 1
                    fi
                """
            }
        }
    }
}
