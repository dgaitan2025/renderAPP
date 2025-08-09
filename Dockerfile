FROM node:18-bullseye-slim AS builder
WORKDIR /app
COPY package*.json ./
# Tools por si hay deps nativas
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
# Si usas privados:
# ARG NPM_TOKEN
# RUN npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN
RUN npm ci --verbose
COPY . .
RUN npm run build

FROM node:18-bullseye-slim
WORKDIR /app
RUN npm i -g serve
COPY --from=builder /app/build ./build
ENV PORT=3000
EXPOSE 3000
CMD ["sh","-c","serve -s build -l ${PORT}"]

