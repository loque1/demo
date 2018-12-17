FROM alpine:3.8

ARG REPOSERVER 
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ARG HTTP_PROXY_AUTH
ARG APP_GROUP
ARG APP_USER



ENV HTTP_PROXY=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    http_proxy=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    HTTPS_PROXY=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    https_proxy=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    FTP_PROXY=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    ftp=${HTTP_PROXY:-http://proxy.sky.local:3128} \
    NO_PROXY=${NO_PROXY:-::1,127.0.0.1,localhost,.sky.local,.dev.sky.local,.systest.sky.local,.uat.sky.local,.sit.sky.local,*.eu-west-2.amazonaws.com} \
    HTTP_PROXY_AUTH=${HTTP_PROXY_AUTH:-'basic:*'}


ENV APP_GROUP=${APP_GROUP:-"skytest"} \
    APP_USER=${APP_USER:-"skytest"}  \
    APP_GROUP_UID="1001" \
    APP_USER_UID="1001" \
    http_proxy=${HTTP_PROXY} \ 
    https_proxy=${HTTPS_PROXY} \ 
    no_proxy=${NO_PROXY}


RUN set -x \
    && apk --no-cache update \
    && apk --no-cache add tzdata jq curl wget bash netcat-openbsd bind-tools \
    && cp /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo "Europe/London" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/telegraf/telegraf.d


#Create the correct user to run the service at when it is stood up
COPY ./assets/create_user /etc/cont-init.d/01_create_user
#This is a tool depending only on bash to to some templating in configuration file using mustache style templating
COPY ./assets/mo /bin/mo

#might need to move this as I am not sure it should be part of base.
COPY ./assets/telegraf.conf /etc/telegraf/telegraf.conf
COPY ./assets/telegraf /etc/telegraf
COPY ./assets/s6.tar.gz /tmp/s6.tar.gz

RUN set -x \
    && tar xzf /tmp/s6.tar.gz -C / \
    && rm -f /tmp/*.gz

#S6 entry point that will launch and control all services 
ENTRYPOINT ["/init"]
