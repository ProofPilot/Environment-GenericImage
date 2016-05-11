FROM proofpilot/environment-genericimage:frontend
MAINTAINER Volodymyr Sheptytsky <vshept@hotmail.com>

RUN /bin/bash -l -c "gem install aptible-cli"

CMD ["/usr/local/bin/start.sh"]