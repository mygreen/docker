# Dockerfile for GitBucket

FROM mygreen/base:centos7
MAINTAINER mygreen

LABEL title="mygreen/gitbucket" \
      version="centos7" \
      description="This image is GitBucket with CentOS 7"

ENV GITBUCKET_LIB="/usr/lib/gitbucket" \
    GITBUCKET_HOME="/var/lib/gitbucket" \
    USER=gitbucket \
    GROUP=gitbucket

ARG version="4.8"
ARG uid=1000
ARG gid=1000

# install jdk
RUN yum -y install java-1.8.0-openjdk

# download war
ADD https://github.com/gitbucket/gitbucket/releases/download/${version}/gitbucket.war $GITBUCKET_LIB/gitbucket.war

# create user
RUN /usr/sbin/groupadd -g ${gid} ${GROUP}
RUN /usr/sbin/useradd -d "$GITBUCKET_HOME" -u ${uid} -g ${gid} -s /bin/false -c "GitBucket Git Repository Server" ${USER}

# setup file
COPY templates/gitbucket.conf $GITBUCKET_LIB/gitbucket.conf
COPY templates/gitbucket.sh $GITBUCKET_LIB/gitbucket.sh
COPY templates/startup.sh $GITBUCKET_LIB/startup.sh
COPY templates/update.sh $GITBUCKET_LIB/update.sh

RUN chmod a+x $GITBUCKET_LIB/*.sh \
 && chown -R $USER:$GROUP $GITBUCKET_LIB

# setup GITBUCKET_HOME
VOLUME $GITBUCKET_HOME

# Port for web page
EXPOSE 8080

# Port for SSH access to git repository (Optional)
EXPOSE 29418

# setup service
COPY templates/gitbucket.service /etc/systemd/system/gitbucket.service
RUN systemctl enable gitbucket

CMD ["/sbin/init"]
