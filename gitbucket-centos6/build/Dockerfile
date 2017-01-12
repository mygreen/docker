# Dockerfile for Jenkins

FROM mygreen/centos6-base:1.0
MAINTAINER mygreen

LABEL title="mygreen/gitbucket" \
      version="1.0" \
      description="This image is GitBucket with CentOS 6"

ENV GITBUCKET_LIB="/usr/lib/gitbucket/" \
    GITBUCKET_HOME="/var/lib/gitbucket" \
    GITBUCKET_VERSION="4.8"

ENV USER=gitbucket \
    GROUP=gitbucket \
    UID=1000
    GID=1000

# install jdk
RUN yum -y install java-1.8.0-openjdk

# download war
ADD https://github.com/gitbucket/gitbucket/releases/download/${GITBUCKET_VERSION}/gitbucket.war $GITBUCKET_LIB/gitbucket.war

# create user
RUN /usr/sbin/groupadd -g ${GID} ${GROUP}
RUN /usr/sbin/useradd -d "$GITBUCKET_HOME" -u ${UID} -g ${GID} -s /bin/false -c "GitBucket Git Repository Server" ${USER}

# setup file
COPY templates/gitbucket.conf $GITBUCKET_LIB/gitbucket.conf
COPY templates/startup.sh $GITBUCKET_LIB/startup.sh
COPY templates/gitbucket.sh $GITBUCKET_LIB/gitbucket.sh
COPY templates/update.sh $GITBUCKET_LIB/update.sh

RUN chmod a+x $GITBUCKET_LIB/*.sh \
 && chown -R $USER:$GROUP $GITBUCKET_LIB \
 && ln -s $GITBUCKET_LIB/gitbucket.sh /etc/init.d/gitbucket

# setup GITBUCKET_HOME
VOLUME $GITBUCKET_HOME

# Port for web page
EXPOSE 8080

# Port for SSH access to git repository (Optional)
EXPOSE 29418

# setup service
COPY templates/init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]
