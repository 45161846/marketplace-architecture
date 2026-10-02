# Компиляция приложения внутри Linux-образа с Go.
FROM golang:1.26.8 AS build
WORKDIR /src

COPY go.mod ./
COPY services/orders/ ./services/orders/
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /out/orders ./services/orders

# Для запуска статически собранного приложения компилятор не нужен.
FROM scratch
COPY --from=build /out/orders /orders
USER 10001:10001
EXPOSE 8080
ENTRYPOINT ["/orders"]
