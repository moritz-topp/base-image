FROM alpine:3.12

# Install
RUN apk update \
    && apk upgrade \
    && apk add \
    apache2 bash ca-certificates curl nano openssl openssh openntpd tzdata \
    php7 php7-apache2 php7-curl php7-iconv php7-json php7-mysqli php7-openssl php7-pdo_mysql php7-phar php7-session

RUN cp /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/*

# Apache Config
RUN sed -i "/LoadModule rewrite_module/s/^#//g" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app#" /etc/apache2/httpd.conf  \
    && sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/public\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf \
    && printf "\nAccessFileName .htaccess\n" >> /etc/apache2/httpd.conf \
    && printf "\n<FilesMatch \"^\.ht\">\n\tRequire all denied\n</FilesMatch>\n" >> /etc/apache2/httpd.conf

# PHP Config
RUN sed -i "s/\;\?\\s\?memory_limit = .*/memory_limit = -1/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?display_errors = .*/display_errors = Off/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?post_max_size = .*/post_max_size = 128M/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?default_charset = .*/default_charset = 'UTF-8'/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?file_uploads = .*/file_uploads = On/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?upload_max_filesize = .*/upload_max_filesize = 128M/" /etc/php7/php.ini
RUN sed -i "s/\;\?\\s\?max_file_uploads = .*/max_file_uploads = 20/" /etc/php7/php.ini

RUN mkdir /app && chown -R apache:apache /app && chmod -R 755 /app

EXPOSE 80

CMD httpd -D FOREGROUND
