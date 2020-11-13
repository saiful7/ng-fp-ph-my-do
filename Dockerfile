FROM ubuntu:latest

#APT local mirror
ADD config/sources.list /etc/apt/sources.list

#TimeZone to Dhaka/Bangladesh
ENV TZ=Asia/Dhaka
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt update && apt-get install -y --no-install-recommends \
        nginx \
        php-cli php-curl php-fpm php-mysql php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip \
        mysql-server \
        supervisor \
        htop \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN echo "<?php phpinfo(); ?>" > /var/www/html/info.php

ADD config/nginx.conf /etc/nginx/sites-enabled/default


EXPOSE 80
# CMD nginx -g "daemon off;"
# # docker run -p88:80 saiful-wp


# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]