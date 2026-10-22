FROM tomcat:9.0-jdk17

# Eliminar las aplicaciones por defecto de Tomcat para limpiar el servidor
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar tu archivo WAR y renombrarlo como ROOT.war para que se ejecute en la raíz de la web
COPY Proyectomcm.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
