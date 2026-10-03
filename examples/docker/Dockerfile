# Educational production-shaped example.
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace
COPY . .

# Replace with the project's reproducible build:
# RUN ./mvnw -B -DskipTests package

FROM eclipse-temurin:21-jre
RUN useradd --system --uid 10001 appuser
WORKDIR /app

# Replace with the real artifact:
# COPY --from=build /workspace/target/app.jar /app/app.jar

USER 10001
EXPOSE 8080

# Exec form lets signals reach the JVM directly.
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
