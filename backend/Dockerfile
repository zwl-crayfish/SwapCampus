FROM openjdk:17-jdk-slim

WORKDIR /app

# 安装 maven wrapper
COPY mvnw pom.xml ./
COPY .mvn .mvn
COPY src src

RUN chmod +x mvnw && ./mvnw package -DskipTests

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/swapcampus-1.0.0.jar"]
