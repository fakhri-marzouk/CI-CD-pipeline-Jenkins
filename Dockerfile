FROM openjdk:11
COPY ./target/gomycode.jar /usr/app/
WORKDIR /usr/app
EXPOSE 8084
ENTRYPOINT ["java","-jar","gomycode.jar"]