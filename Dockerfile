FROM golang:1.16.4-alpine as base
WORKDIR /app/go
COPY . .
RUN go mod download

FROM base as image-dev
RUN go get github.com/cosmtrek/air
EXPOSE 9000
CMD $(go env GOPATH)/bin/air

FROM base as builder
RUN mkdir dist
RUN go build -o dist/web .

FROM alpine:3.15 as image-prod
WORKDIR /app
COPY --from=builder ./app/go/dist/ ./
EXPOSE 9000
CMD  ./web