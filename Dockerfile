FROM nginx
USER root


# Copy your application files
COPY . /usr/share/nginx/html


