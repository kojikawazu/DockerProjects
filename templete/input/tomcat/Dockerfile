FROM centos:7

ADD files/* /opt/

RUN /bin/chmod +x /opt/*.sh && /bin/bash /opt/build.sh

VOLUME [ "/sys/fs/cgroup" ]

CMD [ "/opt/start.sh" ]
