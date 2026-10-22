FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
# Entra a la carpeta del proyecto si está anidada (cambia "Proyectomcm" por el nombre real de tu carpeta si es distinto)
WORKDIR /app/Proyectomcm 
RUN mvn clean package

FROM tomcat:10.1-jdk17
COPY --from=build /app/Proyectomcm/target/Proyectomcm.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
