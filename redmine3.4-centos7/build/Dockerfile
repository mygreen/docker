# Dockerfile for Redmine3.4

FROM mygreen/base:centos7
MAINTAINER mygreen

LABEL title="mygreen/redmine3.4" \
      version="centos7" \
      description="This image is Redmine3.4 on CentOS 7"

ENV REDMINE_HOME="/var/lib/redmine"
ARG redmineVersion=3.4.2
ARG rubyVersion1=2.4
ARG rubyVersion2=2.4.1

# install module
RUN yum -y install openssl-devel readline-devel zlib-devel curl-devel libyaml-devel libffi-devel \
 && yum -y install sqlite sqlite-devel \
 && yum -y install httpd httpd-devel \
 && yum -y install ImageMagick ImageMagick-devel ipa-pgothic-fonts \
 && yum -y install subversion subversion-devel subversion-javahl git \
 && yum clean all

# install ruby
ADD https://cache.ruby-lang.org/pub/ruby/${rubyVersion1}/ruby-${rubyVersion2}.tar.gz /usr/local/src/ruby-${rubyVersion2}.tar.gz
RUN tar zxf /usr/local/src/ruby-${rubyVersion2}.tar.gz -C /usr/local/src/ \
 && cd /usr/local/src/ruby-${rubyVersion2}/ \
 && ./configure --disable-install-doc \
 && make && make install

# install bundler
RUN gem install bundler --no-rdoc --no-ri

# download redmine source
ADD http://www.redmine.org/releases/redmine-${redmineVersion}.tar.gz /usr/local/src/redmine-${redmineVersion}.tar.gz
RUN tar zxf /usr/local/src/redmine-${redmineVersion}.tar.gz -C /var/lib/ \
 && ln -s /var/lib/redmine-${redmineVersion} ${REDMINE_HOME}

# edit database.yml
COPY templates/database.yml ${REDMINE_HOME}/config/database.yml

# edit configuration.yml
RUN /bin/cp -f ${REDMINE_HOME}/config/configuration.yml.example ${REDMINE_HOME}/config/configuration.yml
RUN sed -i -e "s/^  rmagick_font_path:$/  rmagick_font_path: \/usr\/share\/fonts\/ipa-pgothic\/ipagp.ttf/g" ${REDMINE_HOME}/config/configuration.yml

# install gem package
RUN cd ${REDMINE_HOME} \
 && bundle install --without development test --path vendor/bundle

# init data
RUN cd ${REDMINE_HOME} \
 && bundle exec rake generate_secret_token \
 && RAILS_ENV=production bundle exec rake db:migrate \
 && RAILS_ENV=production REDMINE_LANG=ja bundle exec rake redmine:load_default_data

# setup Passenger
RUN gem install passenger --no-rdoc --no-ri \
 && passenger-install-apache2-module --auto

# edit redmine.conf for apache
COPY templates/redmine.conf /etc/httpd/conf.d/redmine.conf


# edit httpd.conf
RUN sed -i -e "s/^\#ServerName www.example.com:80$/ServerName localhost/g" /etc/httpd/conf/httpd.conf

RUN ln -s ${REDMINE_HOME}/public /var/www/html/redmine
RUN chown -R apache:apache ${REDMINE_HOME}/

# remove source
RUN rm -rf /usr/local/src/*

# setup service
RUN systemctl enable httpd

# port
EXPOSE 80

CMD ["/sbin/init"]
