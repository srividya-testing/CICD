# Stage 1: Build
FROM node:20-alpine AS builder

# Install dependencies needed for building native modules
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files first to leverage Docker cache
COPY app/package.json ./package.json
COPY app/package-lock.json ./package-lock.json

# Install production dependencies only
RUN npm ci --omit=dev

# Copy app source code
COPY app/ .

# Stage 2: Run
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only production dependencies and source code
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

# Expose app port (adjust as needed)
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
