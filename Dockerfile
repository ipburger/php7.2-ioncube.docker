FROM webdevops/php-apache:7.2

RUN mkdir -p setup && cd setup && \
  curl -sSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz && \
  tar -xzf ioncube.tar.gz && \
  export PHP_EXT_DIR=$(php-config --extension-dir) && \
  mv ./ioncube/ioncube_loader_lin_7.2.so  $PHP_EXT_DIR/ && \
  echo "zend_extension = $PHP_EXT_DIR/ioncube_loader_lin_7.2.so" >> /opt/docker/etc/php/php.ini && \
  cd .. && rm -rf setup

# from https://github.com/docker-library/php/issues/75 AND https://github.com/webdevops/Dockerfile/blob/master/docker/php-official/7.0/Dockerfile
RUN apt-get update \
  && apt-get install -y libc-client-dev libkrb5-dev libxml2-dev \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap \
  && docker-php-ext-install xmlrpc \
  && apt-get purge -y -f --force-yes libxml2-dev libc-client-dev libkrb5-dev \
  && docker-image-cleanup
