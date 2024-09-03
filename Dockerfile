# We will implement multi-stage builds to reduce the size of the final image. The first stage will be used to build the application and the second stage will be used to run the application.


FROM golang:1.22.5 as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

#final stage - distroless image

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static/ ./static/

EXPOSE 8080

CMD [ "./main" ]



