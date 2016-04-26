FROM ernestova/centos7php56u
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

# Install dependencies
RUN yum install -y git \
    gcc \
    libstdc++-devel \
    gcc-c++ \
    curl-devel \
    libxml2-devel \
    openssl-devel \
    mailcap \
    fuse-libs \
    wget

RUN cd /usr/src && \
    wget https://github.com/libfuse/libfuse/releases/download/fuse_2_9_5/fuse-2.9.5.tar.gz && \
    tar xzf fuse-2.9.5.tar.gz && \
    cd fuse-2.9.5 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ldconfig && \
    modprobe fuse || \
    cd /usr/src/ && \
    wget https://s3fs.googlecode.com/files/s3fs-1.74.tar.gz && \
    tar xzf s3fs-1.74.tar.gz && \
    cd s3fs-1.74 && \
    ./configure --prefix=/usr/local && \
    make && make install
	
RUN curl -sS https://getcomposer.org/installer | php  \
 && mv composer.phar /usr/local/bin/composer
	
# PHP Setup Upload Max
RUN sed -iE "s/upload\_max\_filesize\ \=\ 2M.*/upload\_max\_filesize\ \=\ 256M/" /etc/php.ini \
 && sed -iE "s/post\_max\_size\ =\ 8M.*/post\_max\_size\ =\ 256M/" /etc/php.ini


EXPOSE 80
