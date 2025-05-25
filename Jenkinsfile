pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Build') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'docker build -t yourdockerhubusername/dev:latest .'
                    } else if (env.BRANCH_NAME == 'master') {
                        sh 'docker build -t yourdockerhubusername/prod:latest .'
                    }
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                            sh 'docker push yourdockerhubusername/dev:latest'
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                            sh 'docker push yourdockerhubusername/prod:latest'
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh '''
                            docker stop dev-app || true
                            docker rm dev-app || true
                            docker run -d -p 80:80 --name dev-app yourdockerhubusername/dev:latest
                        '''
                    }
                }
            }
        }
    }
}
