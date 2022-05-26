FROM line/kubectl-kustomize:1.24.0-4.5.5

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache git openssh \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENV PLUGIN_GIT_TOKEN=
ENV PLUGIN_SSH_KEY=
ENV PLUGIN_IMAGES=
ENV PLUGIN_IMAGE_TAG=
ENV PLUGIN_MANIFEST_HOST=
ENV PLUGIN_MANIFEST_USER=
ENV PLUGIN_MANIFEST_USER_EMAIL=
ENV PLUGIN_MANIFEST_NAMESPACE=
ENV PLUGIN_MANIFEST_REPO=
ENV PLUGIN_MANIFEST_BRANCH=
ENV PLUGIN_KUSTOMIZATION=

ENTRYPOINT ["/bin/entrypoint.sh"]
