FROM golang:1.16-alpine
RUN apt-get update && apt-get --assume-yes install jq
WORKDIR /go/src/app
COPY app .
EXPOSE 8080
#RUN  go mod init api && go mod tidy

ENTRYPOINT ["go","run","main.go"]