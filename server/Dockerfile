FROM crystallang/crystal:1.9.2-alpine

WORKDIR /app-server

COPY shard.yml shard.lock ./
RUN shards install
COPY . .

RUN crystal build --release src/app.cr -o /app-server/app

EXPOSE 3000
CMD ["/app-server/app" ]