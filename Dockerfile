FROM library/debian:9

ENV container docker
ENV DEBIAN_FRONTEND "noninteractive"
ENV NOTVISIBLE "in users profile"

ADD bin/dockerrun.sh /root/dockerrun.sh
ADD bin/dockerexec.sh /root/dockerexec.sh
ADD etc/.vimrc /root/.vimrc
ADD etc/.vimrc /etc/skel/.vimrc

RUN /root/dockerrun.sh

STOPSIGNAL SIGRTMIN+3

CMD ["/root/dockerexec.sh", "-D"]
EXPOSE 22
