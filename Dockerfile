FROM proofpilot/environment-genericimage:latest
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

#==========================================


ENV PROJECT=/sites/frontend


# Install dependencies
#----------------------
RUN yum install -y epel-release
#RUN rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#RUN rpm -i https://centos7.iuscommunity.org/ius-release.rpm
#RUN rpm -i https://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm

RUN yum install -y  supervisor git mailcap fuse-libs wget \
  gcc gcc-c++ libstdc++-devel make \
  curl-devel libxml2-devel openssl-devel \
  bind-utils net-tools iproute mysql
  
#RUN rpm -i http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
# && yum install -y  nginx

RUN yum install -y centos-release-scl-rh \
 && yum install -y devtoolset-3 devtoolset-3-gcc devtoolset-3-binutils devtoolset-3-gcc-c++
 
RUN curl --silent --location https://rpm.nodesource.com/setup_5.x | bash - \
 && yum -y install nodejs
 
RUN yum clean all

# Install Ruby And Gems
RUN echo "gem: --no-document" >> ~/.gemrc \
 && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
 && curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --ruby \
 && /bin/bash -l -c "gem install compass"

# Install Bower & Grunt
RUN npm install -g bower gulp
 

RUN rm /etc/nginx/conf.d/default.conf \
 && rm /etc/nginx/conf.d/example_ssl.conf \
 && rm -rf /root/.npm
# && npm cache clean

# Forward request and error logs to docker log collector
#-------------------------------------------------------
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stdout /var/log/nginx/error.log

COPY etc/ /etc/





COPY files/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh




#================================ 
 
RUN chmod -R a+w,a+r /var/log /var/cache /var/run 

#================================

EXPOSE 8080

CMD ["/usr/local/bin/start.sh"] 