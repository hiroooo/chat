From centos:centos6
MAINTAINER Hiroaki Suzuki <suzuki@tribe-univ.com>

ENV IP 127.0.0.1
ENV PW password

RUN yum update -y
RUN yum install wget -y
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm ;\
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm ;\
    wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ;\
    rpm -ivh epel-release-6-8.noarch.rpm remi-release-6.rpm rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN yum --enablerepo=remi,epel,treasuredata install sudo openssh-server syslog nginx monit -y

ADD monit.sshd /etc/monit.d/sshd

#ADD td-agent.conf /etc/td-agent/td-agent.conf
ADD monit.conf /etc/monit.conf
#RUN chown -R root:root /etc/monit.d/ /etc/td-agent/td-agent.conf /etc/monit.conf
#RUN chmod -R 600 /etc/td-agent/td-agent.conf /etc/monit.conf

RUN touch /etc/sysconfig/network
RUN mkdir -m 700 /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && chown root:root /root/.ssh/authorized_keys

RUN useradd chat && echo "chat:$PW" | chpasswd
RUN echo 'chat ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/chat
