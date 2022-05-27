FROM node:16.15.0  as build-step
RUN mkdir -p /3nglearn
WORKDIR /3nglearn
COPY package*.json /3nglearn
RUN npm install
RUN npm ci --only=production
COPY . .
EXPOSE 3002
CMD [ "node", "server.js" ]
