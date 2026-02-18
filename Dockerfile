FROM ubuntu:24.04

ENV NGINX_VERSION=1.28.0
ENV NGINX_RTMP_MODULE_VERSION=1.2.2

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential wget git ffmpeg unzip \
    libpcre3 libpcre3-dev \
    zlib1g zlib1g-dev \
    libssl-dev \
    libxml2 libxml2-dev \
    libxslt1-dev \
    libgd-dev \
    geoip-database libgeoip-dev \
    perl perl-modules \
    && rm -rf /var/lib/apt/lists/*

# Create nginx user
RUN useradd -r -s /sbin/nologin nginx

WORKDIR /tmp

# Download nginx source
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz

# Download nginx-rtmp-module
RUN wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -xzf v${NGINX_RTMP_MODULE_VERSION}.tar.gz

# Download OpenSSL
RUN wget https://www.openssl.org/source/openssl-3.0.13.tar.gz && \
    tar -xzf openssl-3.0.13.tar.gz

# Compile nginx with RTMP module
RUN cd nginx-${NGINX_VERSION} && \
    ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib64/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --with-http_xslt_module \
    --with-http_image_filter_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-openssl=../openssl-3.0.13 \
    --add-module=../nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} && \
    make -j$(nproc) && \
    make install

# Create HLS directory
RUN mkdir -p /tmp/hls && chown nginx:nginx /tmp/hls
RUN mkdir -p /var/log/nginx && chown nginx:nginx /var/log/nginx

# Copy nginx config (will be mounted via ConfigMap in K8s)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 1935
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]