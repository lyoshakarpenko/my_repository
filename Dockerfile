FROM tomcat:8.0
ARG version=1.0.0
RUN cd /usr/share/tomcat/webapps
RUN pwd
RUN curl -u admin:admin123 -o gradleSample.war "http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/${version}/gradleSample-${version}.war" -L
EXPOSE 8080
