FROM library/debian:9

ENV container docker
ENV DEBIAN_FRONTEND "noninteractive"
ENV NOTVISIBLE "in users profile"

ADD bin/dockerrun.sh /root/dockerrun.sh
ADD bin/systemd.sh /root/systemd.sh

RUN /root/dockerrun.sh

STOPSIGNAL SIGRTMIN+3
CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
