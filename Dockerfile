FROM tomcat:latest
ARG version=1.0.0
RUN curl -o /usr/local/tomcat/webapps/gradleSample.war http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/${version}/gradleSample-${version}.war -L
