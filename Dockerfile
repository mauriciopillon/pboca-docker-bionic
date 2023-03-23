# Docker for modified BOCA
################################################################################################
### Versão Inicial: João Vicente Lima
### Versão atualizada: Maurício Aronne PILLON
### Última Modificação: 23/03/2023
### Distributor ID: Ubuntu
### Description:    Ubuntu 18.04.6 LTS
### Release:        18.04
### Codename:       bionic
### PHP 5.6.40-65+ubuntu18.04.1+deb.sury.org+1 (cli) 
#### Copyright (c) 1997-2016 The PHP Group
#### Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
####    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies
################################################################################################

FROM ubuntu:bionic

RUN apt -y update
RUN apt -y install tzdata locales software-properties-common --no-install-recommends
RUN echo "America/Sao_Paulo" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN locale-gen en_US en_US.UTF-8
RUN locale -a
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN apt-get -y update
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:ondrej/php

RUN apt-get -y update
RUN apt -y install postgresql-client apache2 php-common libzip-dev php5.6-zip libapache2-mod-php5.6 php5.6 php5.6-cli php5.6-cgi php5.6-gd php5.6-mcrypt php5.6-pgsql mcrypt git makepasswd zlib1g zlib1g-dev gcc g++ libxml2 libxml2-dev unzip zip vim

ENV GIT_SSL_NO_VERIFY true
#RUN git clone https://gitlab.inf.ufsm.br/jvlima/boca.git /var/www/boca
#RUN git clone https://github.com/joao-lima/boca.git /var/www/boca
RUN git clone https://github.com/mauriciopillon/jvlboca /var/www/boca

ENV APACHE_CONFDIR=/etc/apache2
ENV APACHE_ENVVARS=$APACHE_CONFDIR/envvars
RUN echo APACHE_ENVVARS
RUN set -ex \
	\
# generically convert lines like
#   export APACHE_RUN_USER=www-data
# into
#   : ${APACHE_RUN_USER:=www-data}
#   export APACHE_RUN_USER
# so that they can be overridden at runtime ("-e APACHE_RUN_USER=...")
	&& sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS" \
	\
# setup directories and permissions
	&& . "$APACHE_ENVVARS" \
	&& for dir in \
		"$APACHE_LOCK_DIR" \
		"$APACHE_RUN_DIR" \
		"$APACHE_LOG_DIR" \
		/var/www/html \
	; do \
		rm -rvf "$dir" \
		&& mkdir -p "$dir" \
		&& chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
	done

# Apache + PHP requires preforking Apache for best results
RUN a2dismod mpm_event && a2enmod mpm_prefork
RUN phpenmod mcrypt
# logs should go to stdout / stderr
RUN set -ex \
	&& . "$APACHE_ENVVARS" \
	&& ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
        && ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

# Add startup script to the container.
#COPY apache2-foreground /usr/local/bin/
COPY apache2-foreground /
COPY startup.sh /startup.sh

WORKDIR /var/www/boca
RUN cp tools/etc/apache2/conf.d/boca /etc/apache2/sites-enabled/000-boca.conf
RUN echo bocadir=/var/www/boca > /etc/boca.conf

RUN chown -R www-data:www-data /var/www/boca
RUN chmod 600 /var/www/boca/src/private/conf.php

EXPOSE 80
CMD ["/bin/bash", "/startup.sh"]

