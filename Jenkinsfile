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


		stage('Deploy to staging') {
			steps {
				sh "scp -i /var/lib/jenkins/sakey -o StrictHostKeyChecking=no **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat/webapps"
			}
		}
		stege('Deploy to Production') {
			steps {
				sh "scp -i /var/lib/jenkins/sakey -o StrictHostKeyChecking=no **/target/*.war ec2-user@${params.tomcat_prod}:/var/lib/tomcat/webapps"
	}
}

			
