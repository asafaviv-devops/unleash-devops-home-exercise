# ---------- Stage 1: Build ----------
FROM node:18 AS build

WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./
RUN npm install

# Copy the rest of the project files
COPY . .

# Compile TypeScript into JavaScript
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:18-slim AS prod

WORKDIR /app

# Copy only the compiled output from the build stage
COPY --from=build /app/dist ./dist
COPY package*.json ./

# Install only production dependencies (no devDependencies)
RUN npm install --omit=dev

# Document the port the application listens on
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
