FROM crystallang/crystal:1.9.2-alpine

WORKDIR /app-server

COPY shard.yml shard.lock ./
COPY src ./src

RUN shards install
RUN crystal build --release src/app.cr -o /app-server/app

EXPOSE 3000
CMD ["/app-server/app"]