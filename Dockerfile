# Stage 1: Download deps and copy source code
FROM golang:1.16.4-alpine as base
WORKDIR /app/go
COPY . .
RUN go mod download

# Stage 2: run with file watcher for dev env
FROM base as image-dev
RUN go get github.com/cosmtrek/air
EXPOSE 9000
CMD $(go env GOPATH)/bin/air

# Stage 3: Build binary for production
FROM base as builder
RUN mkdir dist
RUN go build -o dist/web .

# Stage 4: Copy binary to a small alpine image and run
FROM alpine:3.15 as image-prod
WORKDIR /app
COPY --from=builder ./app/go/dist/ ./
EXPOSE 9000
CMD  ./web
