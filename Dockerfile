# Usamos Java 17
FROM eclipse-temurin:17-jdk-jammy AS build

# Directorio de trabajo
WORKDIR /app

# Copiamos archivos de build
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Instalamos dependencias (sin tests para agilizar)
RUN ./mvnw dependency:go-offline

# Copiamos el código fuente
COPY src ./src

# Build del proyecto
RUN ./mvnw package -DskipTests

# --- ETAPA FINAL ---
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copiamos el jar desde la etapa build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]
