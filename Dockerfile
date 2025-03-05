FROM golang:1.24

WORKDIR /workspace/source

COPY go.* ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go build -ldflags '-w -extldflags "-static"'

FROM gcr.io/distroless/base:nonroot

RUN mkdir -p /etc/smtprelay

COPY --from=0 /workspace/source/smtprelay /usr/local/bin/smtprelay

# logfile is /dev/null (not /proc/self/fd/1) because logs go to stdout as well
ENTRYPOINT [ "smtprelay" ]
CMD [ "--help" ]
EXPOSE 25
