FROM node:16.15.0  as build-step
RUN mkdir -p /3nglearn
WORKDIR /3nglearn
COPY package*.json /3nglearn
RUN npm install
COPY . /3nglearn
RUN npm install -g @angular/cli
RUN npm run build --prod
#CMD ng serve --host 0.0.0.0

#FROM nginx:1.20.1
FROM nginx:latest

# Clean nginx
#RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-step /3nglearn/dist/3nglearn /usr/share/nginx/html

COPY ./k8s-manifest/bkup-nginx-default.conf /etc/nginx/conf.d/default.conf
# COPY ./k8s-manifest/nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html

# Permission
RUN chown root /usr/share/nginx/html/*
RUN chmod 755 /usr/share/nginx/html/*

# Expose port
EXPOSE 3000

# Start
CMD ["nginx", "-g", "daemon off;"]

