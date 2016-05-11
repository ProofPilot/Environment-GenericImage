FROM proofpilot/environment-genericimage:frontend
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

RUN cat << EOF > /etc/yum.repos.d/mongodb-org-3.2.repo 
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOF

RUN yum install -y mongodb-org-shell mongodb-org-tools

RUN gem install aptible-cli
