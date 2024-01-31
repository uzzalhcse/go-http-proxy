FROM golang:1.21

WORKDIR /go/src/app

COPY . .

RUN go get -d -v ./...

RUN go build -o main .

EXPOSE 80

CMD ["./main"]
