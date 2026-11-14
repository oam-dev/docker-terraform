FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

RUN \
  apk update && \
  apk add bash py3-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssh-client openssl unzip wget mysql-client libc6-compat && \
  pip --no-cache-dir install --break-system-packages -U pip && \
  pip install --no-cache-dir --break-system-packages azure-cli && \
  apk del --purge build

ARG PROVIDERS

VOLUME ["/data"]

WORKDIR /data

# OpenTofu, installed as `tofu` with `terraform` linked to it, so the commands terraform-controller
# runs (terraform init / apply / destroy) work unchanged. The checksums are from the release's
# tofu_<version>_SHA256SUMS, whose GPG signature (key E3E6E43D84CB852EADB0051D0C0AF313E5FD9F80)
# was verified when they were pinned.
ARG TARGETARCH
ARG TOFU_VERSION=1.13.9
ARG TOFU_SHA256_AMD64=b34b327cc1ef07178207b6f2cd1f5276537d3e5b7be316500f6dac50d4c0a857
ARG TOFU_SHA256_ARM64=5dc196dde75b667e4806d358310ec96742774cd0993c54c1237efee5644b69b8
RUN set -eu; \
    case "${TARGETARCH}" in \
      amd64) sha="${TOFU_SHA256_AMD64}" ;; \
      arm64) sha="${TOFU_SHA256_ARM64}" ;; \
      *) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    wget -q -O /tmp/tofu.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_${TARGETARCH}.tar.gz"; \
    echo "${sha}  /tmp/tofu.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/tofu.tar.gz -C /usr/bin tofu; \
    rm /tmp/tofu.tar.gz; \
    ln -s tofu /usr/bin/terraform; \
    terraform version
COPY retrieve_tf_provider.sh /tmp

COPY ossutil /usr/bin

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh

# default provider (alicloud is no longer bundled: a Configuration downloads the version it asks for)
RUN $RETRIEVE_TF_PROVIDER hashicorp random 3.9.1

# additional designated provider
RUN if [ "${PROVIDERS}" = "" ] ;then \
        echo "There is no additional designated provider"; \
    else \
        for provider in ${PROVIDERS//,/ }; do \
            $RETRIEVE_TF_PROVIDER ${provider//\// }; \
        done \
    fi

ENTRYPOINT ["tail", "-f", "/dev/null"]
