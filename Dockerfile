FROM tomcat:8.0
ARG version=1.0.0
RUN echo $version
RUN curl -u admin:admin123 -o gradleSample.war -SL http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/1.0.3/gradleSample-1.0.3.war -L
EXPOSE 8080
