From centos:centos6
MAINTAINER Hiroaki Suzuki <suzuki@tribe-univ.com>

RUN yum update -y
RUN yum install wget -y
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm ;\
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm ;\
    wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ;\
    rpm -ivh epel-release-6-8.noarch.rpm remi-release-6.rpm rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum --enablerepo=remi,epel,treasuredata install sudo openssh-server syslog nginx monit td-agent nodejs npm -y

ADD monit.sshd /etc/monit.d/sshd
ADD nginx.conf /etc/nginx/nginx.conf
ADD log_format.conf /etc/nginx/conf.d/log_format.conf
ADD WebRTC-Experiment/websocket-over-nodejs /var/www

#ADD td-agent.conf /etc/td-agent/td-agent.conf
ADD monit.conf /etc/monit.conf
#RUN chown -R root:root /etc/monit.d/ /etc/td-agent/td-agent.conf /etc/monit.conf
#RUN chmod -R 600 /etc/td-agent/td-agent.conf /etc/monit.conf

RUN touch /etc/sysconfig/network
RUN mkdir -m 700 /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && chown root:root /root/.ssh/authorized_keys

WORKDIR /etc/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

#RUN useradd chat && echo "chat:$PW" | chpasswd
#RUN echo 'chat ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/chat

#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
#CMD ["service","nginx","start"]
CMD ["nginx"]

EXPOSE 80
EXPOSE 443

