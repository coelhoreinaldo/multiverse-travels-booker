FROM node:20.15-alpine

EXPOSE 3001

WORKDIR /app-client

COPY package*.json ./

RUN npm install

COPY . .

# ENTRYPOINT [ "npm" ]

# CMD [ "start" ]