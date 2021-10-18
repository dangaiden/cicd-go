FROM golang:1.16
RUN apt-get update
WORKDIR /go/src/app
COPY app .
EXPOSE 8080
RUN  go mod init api && go mod tidy

ENTRYPOINT ["go","run","server.go"]