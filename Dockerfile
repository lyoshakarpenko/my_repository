FROM tomcat:8.0
ARG version=1.0.0
RUN curl -u admin:admin123 "http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/${version}/gradleSample-${version}.war"  -o /usr/share/tomcat/webapps/gradleSample.war
EXPOSE 8080
