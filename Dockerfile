FROM proofpilot/environment-genericimage:latest
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>
#=======================================================

# Install dependencies
#-------------------------------------------------------
RUN rpm -i https://centos7.iuscommunity.org/ius-release.rpm

RUN yum makecache \
 && yum install -y php56u php56u-common php56u-fpm php56u-cli php56u-devel \
    php56u-gd php56u-intl php56u-process php56u-mcrypt php56u-pdo php56u-mysqlnd php56u-redis php56u-xml php56u-mbstring \
    php56u-pecl-jsonc php56u-pecl-mongo php56u-pecl-geoip php56u-pecl-memcache php56u-pecl-jsonc-devel php56u-pecl-apcu \
 && yum clean all

COPY etc/ /etc/    

# Forward request and error logs to docker log collector
#-------------------------------------------------------
RUN ln -sf /dev/stdout /var/log/php-fpm/error.log \
 && ln -sf /dev/stdout /var/log/php-fpm/www-slow.log \
 && ln -sf /dev/stdout /var/log/php-fpm/www-error.log

RUN chmod -R a+w,a+r /var/log /var/cache /var/run 

# Composer
RUN curl -sS https://getcomposer.org/installer | php  \
 && mv composer.phar /usr/local/bin/composer
