FROM debian:stable-slim
ENV DEBIAN_FRONTEND noninteractive
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    cp /etc/apt/sources.list /etc/apt/sources.list.default &&\
    sed -i 's@archive.ubuntu.com@mirrors.163.com@g' /etc/apt/sources.list &&\
    sed -i 's@security.ubuntu.com@mirrors.163.com@g' /etc/apt/sources.list &&\
    sed -i 's@deb.debian.org@mirrors.163.com@g' /etc/apt/sources.list &&\
    sed -i 's@security.debian.org@mirrors.163.com@g' /etc/apt/sources.list &&\
    sed -i '/debian-security/d' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends --no-install-suggests curl iproute2 netcat tcpdump telnet ca-certificates net-tools locales expect procps inetutils-ping python2 libmariadb-dev default-libmysqlclient-dev &&\
    apt-get install -y --no-install-recommends --no-install-suggests libattr1-dev liblzma-dev libgpgme-dev python2-dev libcairo2-dev libcurl4-openssl-dev libgirepository1.0-dev &&\
    apt-get install -y --no-install-recommends --no-install-suggests build-essential libtool pkg-config autoconf automake make cmake git gperf protobuf-c-compiler &&\
    cd /tmp/ &&\
    curl -sfkL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py &&\
    python2.7 get-pip.py &&\
    pip2 install -r http://192.168.25.219/index.html/waf/jxwaf/requirements.txt &&\
    pip2 install django-sslserver==0.18 &&\
    mkdir -p /usr/local/jxwaf-server &&\
    curl -sfkL http://192.168.25.219/index.html/waf/jxwaf/RC2.tar.gz|tar xzf - -C /usr/local/jxwaf-server --strip-components=1 &&\
    localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8 &&\
    mkdir -p  /usr/local/mysql-client &&\ 
    curl -sfkL http://192.168.25.219/mysql/mysql-client-8.0.25-15.tar.gz |tar xzf - -C /usr/local/mysql-client --strip-components=1 &&\
    apt-get remove --purge -y automake build-essential libtool pkg-config autoconf automake make cmake git gperf protobuf-c-compiler &&\
    apt-get remove --purge -y libattr1-dev liblzma-dev libgpgme-dev python2-dev libcairo2-dev libcurl4-openssl-dev libgirepository1.0-dev &&\
    apt-get upgrade -y &&\
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
    apt-get clean all &&\
    cd / &&\
    rm -rf /var/lib/apt/lists/ &&\
    rm -rf /var/cache/* &&\
    rm -rf /tmp/* &&\
    useradd -r -m -d /opt/app app &&\
    \cp -f /bin/chown /tmp/chowndir &&\
    chown root:root /tmp/chowndir &&\
    chmod 4755 /tmp/chowndir
ENV TZ Asia/Shanghai
ENV LC_ALL zh_CN.UTF-8
WORKDIR /tmp
USER app
COPY Entrypoint.sh /sbin/Entrypoint.sh
CMD ["/bin/bash","/sbin/Entrypoint.sh"]
LABEL maintainer="Jxwaf Manage <By:liuwei Mail:al6008@163.com Date:2022-09-27>"
