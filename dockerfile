FROM node:14-alpine

# Set working directory
WORKDIR /serverdir

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY . .

# Expose server port
EXPOSE 3000

# Start the application
CMD ["node", "main.js"]
