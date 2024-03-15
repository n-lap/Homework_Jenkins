FROM openjdk:17-alpine AS BUILD_IMAGE
RUN apk add --no-cache binutils

ENV APP_HOME=/root/dev/myapp/
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN $JAVA_HOME/bin/jlink \
         --verbose \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /customjre

FROM alpine:latest
ENV JAVA_HOME=/jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN mkdir /app $JAVA_HOME
COPY --from=BUILD_IMAGE /customjre $JAVA_HOME
COPY /root/dev/myapp/build/libs/testing-web-0.0.1.jar /app
WORKDIR /app
EXPOSE 8081
ENTRYPOINT ["/jre/bin/java","-jar","/app/testing-web-0.0.1.jar"]
