FROM node:16.15.0  as build-step
RUN mkdir -p /3nglearn
WORKDIR /3nglearn
COPY package.json /3nglearn
RUN npm install
COPY . /3nglearn
#RUN npm install -g @angular/cli
RUN npm run build --prod
#CMD ng serve --host 0.0.0.0:4200

#FROM nginx:1.20.1
FROM nginx:latest
COPY --from=build-step /3nglearn/dist/3nglearn /usr/share/nginx/html
EXPOSE 4200:80
