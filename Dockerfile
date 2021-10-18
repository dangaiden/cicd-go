FROM golang:alpine3.14
#RUN apt-get update
RUN apk-get update
WORKDIR /go/src/app
COPY app .
EXPOSE 8080
RUN  go mod init api && go mod tidy

ENTRYPOINT ["go","run","test.go"]