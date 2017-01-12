# Dockerfile for Jenkins

FROM mygreen/base:centos7
MAINTAINER mygreen

LABEL title="mygreen/jenkins" \
      version="centos7" \
      description="This image is Jenkins with CentOS 7"

ENV JENKINS_HOME="/var/lib/jenkins"

# install jdk
RUN yum -y install java-1.8.0-openjdk

# install jenkins
# wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
ADD http://pkg.jenkins-ci.org/redhat/jenkins.repo /etc/yum.repos.d/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install jenkins

# setup JENKINS_HOME
VOLUME $JENKINS_HOME
RUN chown jenkins:jenkins "$JENKINS_HOME"

# port
EXPOSE 8080

# setup service
RUN chkconfig jenkins on

CMD ["/sbin/init"]
