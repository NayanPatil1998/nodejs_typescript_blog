# Stage 1: Build the application
# Use specific version
# Use alpine for smaller base image
FROM node:16.17.1-alpine AS build

#Specify working directory for application
WORKDIR /usr/app

# Copy only files which are required to install dependencies
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Run the application
FROM node:16.17.1-alpine

WORKDIR /usr/app

# set production environment
ENV NODE_ENV production

# copy build files from build stage
COPY  --from=build /usr/app/build .

# Copy necessary files
COPY  --from=build /usr/app/package.json .
COPY --from=build /usr/app/.env .

# Use chown command to set file permissions 
RUN chown -R node:node /usr/app
# Install production dependencies only
RUN npm install --omit=dev

# Use non root user
USER node

CMD ["npm","run", "start:prod"]