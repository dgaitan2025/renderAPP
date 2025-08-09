FROM node:18-bullseye-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && ls -la && ls -la dist   # <= debug

FROM node:18-bullseye-slim
WORKDIR /app
RUN npm i -g serve
COPY --from=builder /app/dist ./build        # <- OJO: dist -> build
ENV PORT=3000
EXPOSE 3000
CMD ["sh","-c","serve -s build -l ${PORT}"]
