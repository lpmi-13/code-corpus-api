FROM golang:1.17-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY main.go ./
COPY ./models ./models
COPY ./controllers ./controllers

RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /code-corpus-api

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /code-corpus-api /code-corpus-api

CMD ["/code-corpus-api"]
