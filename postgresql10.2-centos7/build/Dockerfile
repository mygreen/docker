# Dockerfile for PostgreSQL10.2

FROM mygreen/base:centos7
MAINTAINER mygreen

LABEL title="mygreen/postgresql10.2" \
      version="centos7" \
      description="This image is PostgreSQL10.2 on CentOS 7"

ENV PGDATA="/var/lib/pgsql/10/data"

# install rpm
RUN rpm -iUvh https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm

# install module
RUN yum -y install postgresql10 postgresql10-server postgresql10-devel postgresql10-contrib \
 && yum clean all

# init
#RUN /usr/pgsql-10/bin/postgresql-10-setup initdb

# service start and enable
#RUN systemctl enable postgresql-10
#RUN systemctl start postgresql-10

# setup PGDATA
VOLUME $PGDATA
RUN chown postgres:postgres "$PGDATA"

# port
EXPOSE 5432

CMD ["/sbin/init"]
