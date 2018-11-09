FROM tomcat:8.0
ARG version=1.0.0
RUN pwd
RUN curl -u admin:admin123 -o gradleSample.war http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/1.0.3/gradleSample-1.0.3.war -L
RUN COPY gradleSample.war /usr/local/tomcat/webapps/gradleSample.war
EXPOSE 8080
