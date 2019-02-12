FROM openjdk:8-jdk-slim
ENV PORT 8080
EXPOSE 8080
RUN ./gradlew build -info

COPY build/libs/*.jar /opt/app.jar
WORKDIR /opt
CMD ["java", "-jar", "app.jar"]