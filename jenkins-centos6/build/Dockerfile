# Dockerfile for Jenkins

FROM mygreen/base:centos6
MAINTAINER mygreen

LABEL title="mygreen/jenkins" \
      version="centos6" \
      description="This image is Jenkins with CentOS6"

# install jdk
RUN yum -y install java-1.8.0-openjdk

# install jenkins
# wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
ADD http://pkg.jenkins-ci.org/redhat/jenkins.repo /etc/yum.repos.d/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install jenkins

# setup JENKINS_HOME
VOLUME /var/lib/jenkins

# port
EXPOSE 8080

# setup service
COPY templates/init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]
