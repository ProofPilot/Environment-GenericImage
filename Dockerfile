FROM proofpilot/environment-genericimage:latest
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

#==========================================


ENV PROJECT=/sites/frontend


# Install dependencies
#----------------------
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
 
#RUN rm /etc/nginx/conf.d/default.conf \
# && rm /etc/nginx/conf.d/example_ssl.conf \
# && rm -rf /root/.npm
## && npm cache clean

COPY etc/ /etc/

# Forward request and error logs to docker log collector
#-------------------------------------------------------



COPY files/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

#================================ 
RUN chmod -R a+w,a+r /var/log /var/cache /var/run 
#================================

EXPOSE 8080
CMD ["/usr/local/bin/start.sh"] 