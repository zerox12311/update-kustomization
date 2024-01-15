ARG KUSTOMIZE_IMAGE=docker.io/line/kubectl-kustomize:1.28.3-5.2.1

FROM ${KUSTOMIZE_IMAGE}

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
RUN apk update && apk upgrade \
    && apk add --no-cache git openssh \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENV GIT_TOKEN=
ENV SSH_KEY=
ENV IMAGES=
ENV IMAGE_TAG=
ENV MANIFEST_HOST=
ENV MANIFEST_USER=
ENV MANIFEST_USER_EMAIL=
ENV MANIFEST_NAMESPACE=
ENV MANIFEST_REPO=
ENV MANIFEST_BRANCH=
ENV KUSTOMIZATION=

ENTRYPOINT ["/bin/entrypoint.sh"]
