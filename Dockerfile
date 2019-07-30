FROM tomcat:8.0

COPY webapp/target/*.war /usr/local/tomcat/webapps/

EXPOSE 9000
