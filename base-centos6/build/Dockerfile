FROM centos:centos6.8
MAINTAINER mygreen

LABEL title="mygreen/base" \
      version="centos6" \
      description="This image is CentOS6.x for Server Base"

# SELinux OFF
ADD templates/selinux_config /etc/selinux/config

# yum setup
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# install base package
RUN yum -y groupinstall "Base" \
 && yum -y groupinstall "Development Tools" \
 && yum -y groupinstall "Japanese Support" \
 && yum install -y nkf sudo \
 && yum clean all

# setup locale
RUN localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8
ADD templates/sysconfig_i18n /etc/sysconfig/i18n
RUN source /etc/sysconfig/i18n

# setup timezone
ADD templates/sysconfig_clock /etc/sysconfig/clock
RUN /bin/cp -f /usr/share/zoneinfo/Japan /etc/localtime

