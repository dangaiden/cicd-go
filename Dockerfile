FROM golang:1.16
RUN apt-get update && curl -sfL \
https://raw.githubusercontent.com/davesnx/query-json/master/scripts/install.sh | bash
WORKDIR /go/src/app
COPY app .
EXPOSE 8080
RUN  go mod init api && go mod tidy

ENTRYPOINT ["go","run","server.go"]