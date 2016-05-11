FROM proofpilot/environment-genericimage:frontend
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

RUN echo '[mongodb-org-3.2]\n\
name=MongoDB Repository\n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/\n\
gpgcheck=1\n\
enabled=1\n\
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc\n'\
 > /etc/yum.repos.d/mongodb-org-3.2.repo


RUN yum makecache \ 
 && yum install -y mongodb-org-shell mongodb-org-tools

RUN gem install aptible-cli
