pipeline {
	agent any
	parameters {
		string defaultValue: '172.31.11.181', description: 'Tomcat Staging environment', name: 'tomcat_dev', trim: false
		string defaultValue: '172.31.8.150', description: 'Tomcat Prod environment', name: 'tomcat_prod', trim: false
	}

	triggers {
		pollSCM '* * * * *'
	}

	stages {

		stage('Build') {
			
			steps {
				sh 'mvn clean package'
			}

			post {
				success {
				    echo "Archiving now.."
				    archiveArtifacts '**/target/*.war'
				}
			}
		}

		 stage('Deploy to QA') {
                        steps {
                                sh "docker build . -t myapp:${env.BUILD_ID}"
				sh 'docker run -d -rm -p 9000:8080-v /myapp:/usr/local/tomcat/webapps/ -name myapp_${env.BUILD_ID} myapp:${env.BUILD_ID}'
                        }  
                }

	}
}

			
