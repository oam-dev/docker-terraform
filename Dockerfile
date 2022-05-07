FROM alpine:3.13

RUN \
  apk update && \
  apk add bash py-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssl unzip wget mysql-client && \
  pip --no-cache-dir install -U pip && \
  pip install azure-cli && \
  apk del --purge build

VOLUME ["/data"]

WORKDIR /data

ENV TERRAFORM_VERSION=1.0.2
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp
RUN cd /tmp && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
COPY retrieve_tf_provider.sh /tmp

COPY ossutil /usr/bin

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh

RUN $RETRIEVE_TF_PROVIDER random 3.1.0
RUN $RETRIEVE_TF_PROVIDER alicloud 1.140.0

ENTRYPOINT ["tail", "-f", "/dev/null"]
