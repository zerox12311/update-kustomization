FROM line/kubectl-kustomize:1.24.0-4.5.5

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache git openssh

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
