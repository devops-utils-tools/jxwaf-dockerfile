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
    apt-get install -y --no-install-recommends --no-install-suggests curl iproute2 netcat tcpdump telnet ca-certificates net-tools locales expect procps inetutils-ping python2 &&\
    apt-get install -y --no-install-recommends --no-install-suggests libpcre3-dev  libssl-dev  zlib1g-dev &&\
    apt-get install -y --no-install-recommends --no-install-suggests build-essential libtool pkg-config autoconf automake make cmake git gperf protobuf-c-compiler &&\
    cd /tmp/ &&\
    curl -sfkL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py &&\
    python2.7 get-pip.py &&\
    pip2 install requests==2.27.1 &&\
    mkdir -p /tmp/jxwaf-node &&\
    curl -sfkL http://192.168.25.219/index.html/waf/jxwaf/jxwaf2022-RC2.tar.gz|tar xzf - -C /tmp/jxwaf-node --strip-components=1 &&\
    cd /tmp/jxwaf-node/ &&\
    tar zxvf openresty-1.21.4.1.tar.gz  &&\
    cd openresty-1.21.4.1  &&\
    ./configure --prefix=/opt/jxwaf --with-http_v2_module --with-http_stub_status_module && gmake && gmake install  &&\
    mv /opt/jxwaf/nginx/conf/nginx.conf  /opt/jxwaf/nginx/conf/nginx.conf.bak  &&\
    cp ../conf/nginx.conf /opt/jxwaf/nginx/conf/  &&\
    cp ../conf/full_chain.pem /opt/jxwaf/nginx/conf/  &&\
    cp ../conf/private.key /opt/jxwaf/nginx/conf/  &&\
    mkdir /opt/jxwaf/nginx/conf/jxwaf  &&\
    cp ../conf/jxwaf_config.json /opt/jxwaf/nginx/conf/jxwaf/  &&\
    cp -r ../lib/resty/jxwaf  /opt/jxwaf/lualib/resty/  &&\
    cd /opt/jxwaf/ &&\
    tar czf /usr/local/jxwaf.tar.gz * &&\
    cp /tmp/jxwaf-node/tools/jxwaf_init.py /usr/local/jxwaf_init.py &&\
    mkdir -p /etc/pki/tls/certs/ &&\
    cat /etc/ssl/certs/ca-certificates.crt > /etc/pki/tls/certs/ca-bundle.crt  &&\
    localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8 &&\
    apt-get remove --purge -y build-essential libtool pkg-config autoconf automake make cmake git gperf protobuf-c-compiler libpcre3-dev  libssl-dev  zlib1g-dev &&\
    apt-get upgrade -y &&\
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
    apt-get clean all &&\
    cd / &&\
    rm -rf /var/lib/apt/lists/ &&\
    rm -rf /var/cache/* &&\
    rm -rf /tmp/* /opt/jxwaf/ &&\
    useradd -r -m -d /opt/app app &&\
    \cp -f /bin/chown /tmp/chowndir &&\
    chown root:root /tmp/chowndir &&\
    chmod 4755 /tmp/chowndir 
ENV TZ Asia/Shanghai
ENV LC_ALL zh_CN.UTF-8
WORKDIR /tmp
COPY Entrypoint.sh /sbin/Entrypoint.sh
CMD ["/bin/bash","/sbin/Entrypoint.sh"]
LABEL maintainer="Jxwaf Manage <By:liuwei Mail:al6008@163.com Date:2022-09-27>"
