FROM centos:latest
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

#==========================================


# Install dependencies

RUN yum install -y epel-release

#RUN rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -i https://centos7.iuscommunity.org/ius-release.rpm
#RUN rpm -i https://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
RUN rpm -i http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

RUN yum install -y php56u php56u-common php56u-fpm php56u-cli php56u-devel \
  php56u-gd php56u-intl php56u-process php56u-mcrypt php56u-pdo php56u-mysqlnd php56u-redis php56u-xml php56u-mbstring \
  php56u-pecl-jsonc php56u-pecl-mongo php56u-pecl-geoip php56u-pecl-memcache php56u-pecl-jsonc-devel php56u-pecl-apcu

RUN yum install -y  nginx supervisor git mailcap fuse-libs wget \
  gcc gcc-c++ libstdc++-devel \
  curl-devel libxml2-devel openssl-devel \
  bind-utils net-tools iproute
  
RUN yum clean all   

COPY files/supervisord.conf /etc/supervisord.conf
COPY files/services.conf /etc/supervisord.d/services.conf
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/default.conf /etc/nginx/conf.d/default.conf
COPY files/php.ini /etc/php.ini
COPY files/php-fpm.conf /etc/php-fpm.conf
COPY files/www.conf /etc/php-fpm.d/www.conf
COPY files/start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stdout /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/php-fpm/error.log
RUN ln -sf /dev/stdout /var/log/php-fpm/www-slow.log
RUN ln -sf /dev/stdout /var/log/php-fpm/www-error.log

RUN chmod -R a+w,a+r /var/log /var/cache /var/run 

#================================



RUN cd /usr/src && \
    wget https://github.com/libfuse/libfuse/releases/download/fuse-2.9.6/fuse-2.9.6.tar.gz && \
    tar xzf fuse-2.9.6.tar.gz && \
    cd fuse-2.9.6 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ldconfig && \
    modprobe fuse || \
    cd /usr/src/ && \
	git clone https://github.com/s3fs-fuse/s3fs-fuse.git &&\ 
	cd s3fs-fuse && \
    ./autogen.sh && ./configure --prefix=/usr/local && \
    make && make install
	
RUN curl -sS https://getcomposer.org/installer | php  \
 && mv composer.phar /usr/local/bin/composer
	
EXPOSE 8080

CMD ["/usr/local/bin/start.sh"] 