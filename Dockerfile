FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

RUN \
  apk update && \
  apk add bash py3-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssl unzip wget mysql-client libc6-compat && \
  pip --no-cache-dir install --break-system-packages -U pip && \
  pip install --no-cache-dir --break-system-packages azure-cli && \
  apk del --purge build

ARG PROVIDERS

VOLUME ["/data"]

WORKDIR /data

ENV TERRAFORM_VERSION=1.5.5
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp
RUN cd /tmp && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
COPY retrieve_tf_provider.sh /tmp

COPY ossutil /usr/bin

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh

# default provider
RUN $RETRIEVE_TF_PROVIDER hashicorp random 3.1.0
RUN $RETRIEVE_TF_PROVIDER hashicorp alicloud 1.187.0

# additional designated provider
RUN if [ "${PROVIDERS}" = "" ] ;then \
        echo "There is no additional designated provider"; \
    else \
        for provider in ${PROVIDERS//,/ }; do \
            $RETRIEVE_TF_PROVIDER ${provider//\// }; \
        done \
    fi

ENTRYPOINT ["tail", "-f", "/dev/null"]
