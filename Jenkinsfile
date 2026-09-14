// Jenkinsfile
pipeline {
    agent any
    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
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
                sh "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                sh 'docker push aarif2511/dev:latest'
            }
        }
        stage('Build Prod Image') {
            when { branch 'main' }
            steps {
                sh 'docker build -t aarif2511/prod:latest .'
            }
        }
        stage('Push Prod Image') {
            when { branch 'main' }
            steps {
                sh "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                sh 'docker push aarif2511/prod:latest'
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
            cleanWs()
            sh 'docker logout'
        }
    }
}
