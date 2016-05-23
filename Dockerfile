FROM proofpilot/environment-genericimage:frontend
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

RUN yum makecache \
 && yum install -y screen tmux \
 && yum clean all

RUN /bin/bash -l -c "gem install aptible-cli"

CMD ["/usr/local/bin/start.sh"]