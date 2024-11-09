pipeline {
    agent {
        label 'java-slave'
    }
    environment {
        // APP_PORT = '3001'
        // JAR_NAME = 'hello-world-spring-1.0.0.jar'
        DOCKER_IMAGE = 'spring-boot-app'
        DOCKER_TAG = 'latest'
    }
    stages {
        stage('Verify Tools') {
            steps {
                sh '''
                    java -version
                    mvn -version
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                    sh 'mvn clean package -DskipTests'
                // dir('spring-boot-app') {
                // }
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    def commitHash = sh(script: 'git rev-parse --short=6 HEAD', returnStdout: true).trim()
                    def dockerImage = "phuongtn20/backend-app:${commitHash}"

                    withCredentials([usernamePassword(credentialsId: 'phuongtn20-docker', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh "docker build -t ${dockerImage} ."
                        sh "docker push ${dockerImage}"
                    }
                }
            }
        }
        // stage('Test') {
        //     steps {
        //             sh 'mvn test'
        //         // dir('spring-boot-app') {
        //         // }
        //     }
        // }

        // stage('Archive') {
        //     steps {
        //             archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        //         // dir('spring-boot-app') {
        //         // }
        //     }
        // }

        // stage('Build Docker Image') {
        //     steps {
        //             sh 'docker build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} --build-arg JAR_NAME=${JAR_NAME} .'
        //         // dir('spring-boot-app') {
        //         // }
        //     }
        // }

        // stage('Deploy') {
        //     steps {
        //         // dir('spring-boot-app') {
        //         // }
        //             sh '''
        //                 # Stop and remove existing container if it exists
        //                 docker ps -q --filter "name=spring-boot-app" | grep -q . && docker stop spring-boot-app || true
        //                 docker ps -aq --filter "name=spring-boot-app" | grep -q . && docker rm spring-boot-app || true
        //                 # Run the new container
        //                 docker run -d \
        //                     --name spring-boot-app \
        //                     -p ${APP_PORT}:${APP_PORT} \
        //                     ${DOCKER_IMAGE}:${DOCKER_TAG}
        //                 # Wait for the application to start
        //                 sleep 10
        //                 # Check if container is running
        //                 docker ps | grep spring-boot-app
        //                 # Check application logs
        //                 docker logs spring-boot-app
        //             '''

        //     }
        // }
    }
    post {
        success {
            echo 'Backend Docker image pushed successfully.'
        }
    }
}