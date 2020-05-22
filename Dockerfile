# from rabbitmq:3.7.26-management
FROM rabbitmq:3.7.26-management

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
#ARG rabbitmq_delayed_message_exchange_url=https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip
ARG rabbitmq_delayed_message_exchange_url=https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.8.0/rabbitmq_delayed_message_exchange-3.8.0.ez
#ARG rabbitmq_message_timestamp_url=https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_message_timestamp/rabbitmq_message_timestamp-20170830-3.7.x.zip
ARG rabbitmq_message_timestamp_url=https://github.com/rabbitmq/rabbitmq-message-timestamp/releases/download/v3.8.0/rabbitmq_message_timestamp-3.8.0.ez

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
    curl -fsSL ${rabbitmq_delayed_message_exchange_url} -o /plugins/rabbitmq_delayed_message_exchange-3.8.0.ez && \
    curl -fsSL ${rabbitmq_message_timestamp_url} -o /plugins/rabbitmq_message_timestamp-3.8.0.ez && \
    echo "\ndone..."
