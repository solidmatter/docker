# Dockerfile for solidmatter
# https://github.com/solidmatter/solidmatter

FROM debian:stretch

MAINTAINER Heiko Thiery

RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          apache2 \
          php7.0-mysql \
          php7.0-xml \
          php7.0-gd \
          php-mbstring \
          libapache2-mod-php7.0 \
          ca-certificates \
          mariadb-client \
          mariadb-server \
          unzip \
          wget \
          curl \
          supervisor \
          pwgen \
          vim \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

ARG GITREF_SOLIDMATTER=develop
# switch default shell form /bin/sh to /bin/bash to support string replace
# replace '/' from branch name with '-' ... e.g. feature/fix-a -> feature-fix-a
SHELL ["/bin/bash", "-c"]
RUN echo ${GITREF_SOLIDMATTER} > solidmatter_version
RUN mkdir -p /var/www/solidmatter \
    && wget -q --no-cookies -O - "http://github.com/solidmatter/solidmatter/archive/${GITREF_SOLIDMATTER}.tar.gz" \
    | tar xz --strip-components=2 --directory=/var/www/solidmatter -f - solidmatter-${GITREF_SOLIDMATTER//\//-}/solidmatter solidmatter-${GITREF_SOLIDMATTER//\//-}/files


# Update the PHP.ini file, enable <? ?> tags and quieten logging.
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Update the default apache site with the config we created.
#ADD apache-solidmatter.conf /etc/apache2/sites-enabled/000-default.conf
ADD content/ /

# Expose apache.
EXPOSE 80

# By default start up apache in the foreground, override with /bin/bash for interative.
#CMD /usr/sbin/apache2ctl -D FOREGROUND

# Add VOLUMEs to allow backup of config and databases
#VOLUME ["/etc/mysql", "/var/lib/mysql"]
VOLUME ["/var/lib/mysql"]
VOLUME ["/media"]

# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
