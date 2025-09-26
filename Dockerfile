# syntax=docker/dockerfile:1
FROM node:20-alpine AS deps
WORKDIR /app
COPY app/package.json ./package.json
RUN npm ci --omit=dev

FROM node:20-alpine AS runner
ENV NODE_ENV=production
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/ .
# Drop privileges
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser
EXPOSE 3000
CMD ["node", "index.js"]
