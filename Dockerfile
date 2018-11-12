FROM tomcat:8.0
ARG version=1.0.0
RUN curl -u admin:admin123 -o /usr/local/tomcat/webapps/gradleSample.war http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/1.0.5/gradleSample-1.0.5.war -L
EXPOSE 8080
CMD ["catalina.sh", "run"]
