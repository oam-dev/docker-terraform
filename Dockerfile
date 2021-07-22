FROM oamdev/docker-terraform-base:1.0.4

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["tail", "-f", "/dev/null"]

ENV TERRAFORM_VERSION=1.0.2
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp
RUN cd /tmp && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/broadinstitute/docker-terraform"
