
# Defining node image and giving alias as node-helper
# It's better to define version otherwise me might face issue in future build
FROM node:16.15.0 as build-step

#Accepting build-arg to create environment specific build
#it is useful when we have multiple environment (e.g: dev, tst, staging, prod)
#default value is production, (oher values can be development,..)
ARG build_env=production

#Creating virtual directory inside docker image
WORKDIR /app

RUN npm cache clean --force

#Copying file from local machine to virtual docker image directory
COPY . .

#installing deps for project
RUN npm install

#creating angular build, $build_env is command-line argumment
# RUN ./node_modules/@angular/cli/bin/ng build --configuration=$build_env

RUN npm run build --prod

#STEP-2 RUN
#Defining nginx img
FROM nginx:1.20 as ngx

#copying compiled code from dist to nginx folder for serving
COPY --from=build-step /app/dist/3nglearn /usr/share/nginx/html

#copying nginx config from local to image
COPY /k8s-manifest/nginx.conf /etc/nginx/conf.d/default.conf

#exposing internal port
EXPOSE 4200

# Start
CMD ["nginx", "-g", "daemon off;"]
