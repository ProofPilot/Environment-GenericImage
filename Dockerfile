FROM centos:latest
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

#==========================================


# Install dependencies

RUN yum install -y epel-release
RUN rpm -i http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

RUN yum install -y  nginx supervisor git mailcap fuse-libs wget \
          gcc gcc-c++ libstdc++-devel \
          curl-devel libxml2-devel openssl-devel \
          bind-utils net-tools iproute mysql \
 && yum clean all
  
COPY etc/ /etc/

COPY files/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stdout /var/log/nginx/error.log

RUN chmod -R a+w,a+r /var/log /var/cache /var/run 

#================================

EXPOSE 8080

CMD ["/usr/local/bin/start.sh"] 