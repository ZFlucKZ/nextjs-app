FROM node:24.0 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install
RUN npm install -g next@latest

COPY . .

RUN npm run build

FROM node:24.0-alpine AS runner

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next

RUN npm install --omit=dev
RUN npm install -g next@latest

EXPOSE 4000

CMD ["npm", "run", "start"]