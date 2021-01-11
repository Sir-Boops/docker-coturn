FROM alpine:3.12.2

ENV COTURN_VER=4.5.2
ENV PATH=$PATH:/opt/bin

RUN apk add -U --virtual deps gcc g++ \
    pkgconfig openssl-dev libevent-dev \
    linux-headers make && \
  cd ~ && \
  wget https://github.com/coturn/coturn/archive/$COTURN_VER.tar.gz && \
  tar xf $COTURN_VER.tar.gz && \
  rm $COTURN_VER.tar.gz && \
  cd coturn-$COTURN_VER && \
  ./configure --prefix=/opt && \
  make -j$(nproc) && \
  make install && \
  cd ~ && \
  apk del --purge deps && \
  rm -rf coturn-$COTURN_VER && \
  rm -rf /opt/share && \
  rm -rf /opt/man && \
  apk add libevent

CMD turnserver --log-file=stdout
