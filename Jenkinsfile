// Jenkinsfile
pipeline {
    agent any
    environment {
        SSH_KEY = credentials('ec2-ssh-key') 
    }
    stages {
        stage('Build Dev Image') {
            when { branch 'dev' }
            steps {
                sh 'docker build -t aarif2511/dev:latest .'
            }
        }
        stage('Push Dev Image') {
            when { branch 'dev' }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push aarif2511/dev:latest
                    '''
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@your-ec2-ip "
                        cd ~/devops-build
                        docker-compose down
                        docker-compose pull
                        docker-compose up -d
                    "
                    '''
                }
            }
        }
    }
    post {
        always {
            node {
                cleanWs()
                sh 'docker logout'
            }
        }
    }
}