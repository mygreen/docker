FROM centos:centos7
MAINTAINER mygreen

LABEL title="mygreen/base" \
      version="centos7" \
      description="This image is CentOS 7.x for Server Base"

ENV TERM xterm

# SELinux OFF
COPY templates/selinux_config /etc/selinux/config

# yum setup
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# install base package
RUN yum -y groupinstall "Base" \
 && yum -y groupinstall "Development Tools" \
 && yum -y install -y nkf sudo

# setup japanese locale
RUN yum -y install ibus-kkc vlgothic-* \
 && yum reinstall -y glibc-common \
 && yum clean all

RUN localedef -f UTF-8 -i ja_JP ja_JP

#RUN localectl set-locale LANG=ja_JP.utf8
COPY templates/locale.conf /etc/locale.conf
RUN source /etc/locale.conf

#RUN localectl set-keymap jp106 
COPY templates/vconsole.conf /etc/vconsole.conf


# setup timezone
#RUN timedatectl set-timezone Asia/Tokyo
RUN unlink /etc/localtime \
 && ln -s /usr/share/zoneinfo/Japan /etc/localtime

