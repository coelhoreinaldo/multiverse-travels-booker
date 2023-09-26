FROM crystallang/crystal:1.9.2-alpine

EXPOSE 3000

WORKDIR /app-server

COPY shard.yml shard.lock ./
RUN shards install
COPY . .

RUN crystal build --release src/app.cr -o ./app

CMD make sam db:setup && ./app