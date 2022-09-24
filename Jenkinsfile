pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
            NEXUS_VERSION = 'nexus3'
            NEXUS_PROTOCOL = 'http'
            NEXUS_URL = 'localhost:8081'
            NEXUS_REPOSITORY = 'maven-nexus-repo'
            NEXUS_CREDENTIAL_ID = 'nexus-user-credentials'
      }
    stages {
        stage('Build') {
            steps {
                bat 'mvn clean install -Dmaven.test.skip=true'
            }
        }
        stage('Testing'){
            steps{
                //sonarqube
                bat 'mvn test  -DskipTests'
            }
        }
         stage("Build docker image"){
                    steps{
                        script{
                            bat "docker build -t lexicography ."
                        }
                    }
                 }
        stage("Publish to Nexus Repository Manager") {
                    steps {
                        script {
                            pom = readMavenPom file: "pom.xml";
                            filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                            echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                            artifactPath = filesByGlob[0].path;
                            artifactExists = fileExists artifactPath;
                            if(artifactExists) {
                                echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                                nexusArtifactUploader(
                                    nexusVersion: NEXUS_VERSION,
                                    protocol: NEXUS_PROTOCOL,
                                    nexusUrl: NEXUS_URL,
                                    groupId: pom.groupId,
                                    version: pom.version,
                                    repository: NEXUS_REPOSITORY,
                                    credentialsId: NEXUS_CREDENTIAL_ID,
                                    artifacts: [
                                        [artifactId: pom.artifactId,
                                        classifier: '',
                                        file: artifactPath,
                                        type: pom.packaging],
                                        [artifactId: pom.artifactId,
                                        classifier: '',
                                        file: "pom.xml",
                                        type: "pom"]
                                    ]
                                );
                            } else {
                                error "*** File: ${artifactPath}, could not be found";
                            }
                        }
                    }
                }
    }
}
