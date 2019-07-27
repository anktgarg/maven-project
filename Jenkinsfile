pipeline {
	agent any
	parameters {
		string defaultValue: '13.127.141.83', description: 'Tomcat Staging environment', name: 'tomcat_dev', trim: false
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


		stage('Deploy to staging') {
			steps {
				sh "scp -i /var/lib/jenkins/sakey -o StrictHostKeyChecking=no **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat7/webapps"
			}
		}
	}
}

			
