pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }
        stage('Testing'){
            steps{
                //sonarqube
                bat 'mvn test'
            }
        }
    }
}
