FROM node:18-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

# Set non-root user
USER appuser

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
