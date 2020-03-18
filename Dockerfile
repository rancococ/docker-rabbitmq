# from rabbitmq:3.7.24-management
FROM rabbitmq:3.7.24-management

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG rabbitmq_delayed_message_exchange_url=https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip
ARG rabbitmq_message_timestamp_url=https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_message_timestamp/rabbitmq_message_timestamp-20170830-3.7.x.zip

# set some env
ENV DEBIAN_FRONTEND noninteractive

# change ubuntu source to huawei, and install plugins and enable plugins
RUN echo "\nchange ubuntu source to huawei..." && \
    sed -i 's@http://archive.ubuntu.com@http://mirrors.huaweicloud.com@g' /etc/apt/sources.list && \
    sed -i 's@http://security.ubuntu.com@http://mirrors.huaweicloud.com@g' /etc/apt/sources.list && \
    echo "\ninstall some packages..." && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes apt-transport-https ca-certificates curl wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo "\ndownload rabbitmq plugins..." && \
    curl -fsSL ${rabbitmq_delayed_message_exchange_url} -o /tmp/rabbitmq_delayed_message_exchange.zip && \
    curl -fsSL ${rabbitmq_message_timestamp_url} -o /tmp/rabbitmq_message_timestamp.zip && \
    unzip -o /tmp/rabbitmq_delayed_message_exchange.zip -d /plugins/ && \
    unzip -o /tmp/rabbitmq_message_timestamp.zip -d /plugins/ && \
    rm /tmp/rabbitmq_delayed_message_exchange.zip && \
    rm /tmp/rabbitmq_message_timestamp.zip && \
    echo "\nenable rabbitmq plugins..." && \
    rabbitmq-plugins enable --offline rabbitmq_federation_management \
                                      rabbitmq_delayed_message_exchange \
                                      rabbitmq_message_timestamp \
                                      rabbitmq_random_exchange \
                                      rabbitmq_stomp \
                                      rabbitmq_mqtt

# expose port 1883 5672 15672 25672 61613
EXPOSE 1883 5672 15672 25672 61613
