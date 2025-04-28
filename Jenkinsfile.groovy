pipeline {
    agent any

    tools {
        maven 'Maven 3'   // <-- Use the Maven name you set in Jenkins
    }
    environment {
        DOCKER_IMAGE = "wnwls1216/test-spring-app:latest"
    }

    stages {
        stage('Build Maven Project') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh './cicd/docker_push.sh $DOCKER_IMAGE'
                }
            }
        }
        stage('Terraform Apply Infra') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'PROXMOX', usernameVariable: 'PM_TOKEN_ID', passwordVariable: 'PM_TOKEN_SECRET'),
                    string(credentialsId: 'APP_CONTAINER_PASSWORD', variable: 'APP_CONTAINER_PASSWORD')
                ]) {
                    sh './cicd/terraform_deploy.sh'
                }
            }
        }
        stage('Ansible Deploy') {
            steps {
                sh './cicd/ansible_deploy.sh $DOCKER_IMAGE'
            }
        }
    }

}