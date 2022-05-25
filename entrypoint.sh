#!/bin/sh
# apk update && apk add --no-cache git && apk add --no-cache openssh
if [ -z "$PLUGIN_SSH_KEY" ]
then
    GIT_REPO_URI="https://$PLUGIN_GIT_TOKEN@$PLUGIN_MANIFEST_HOST/${PLUGIN_MANIFEST_NAMESPACE:-${PLUGIN_MANIFEST_USER}}/$PLUGIN_MANIFEST_REPO.git"
else
    mkdir -p ~/.ssh && echo $PLUGIN_SSH_KEY | base64 -d > ~/.ssh/id_rsa && chmod 700 ~/.ssh/id_rsa && ssh-keyscan $PLUGIN_MANIFEST_HOST >> ~/.ssh/known_hosts
    GIT_REPO_URI="ssh://git@$PLUGIN_MANIFEST_HOST/${PLUGIN_MANIFEST_NAMESPACE:-${PLUGIN_MANIFEST_USER}}/$PLUGIN_MANIFEST_REPO.git"
fi

rm -rf $PLUGIN_MANIFEST_REPO && git clone $GIT_REPO_URI

cd $PLUGIN_MANIFEST_REPO
git checkout $PLUGIN_MANIFEST_BRANCH
cd $PLUGIN_KUSTOMIZATION

for IMAGE in $(echo $PLUGIN_IMAGES | sed "s/,/ /g")
do
    echo "kustomize edit set image $IMAGE:$PLUGIN_IMAGE_TAG"
    kustomize edit set image $IMAGE:$PLUGIN_IMAGE_TAG
done

git config --global user.name $PLUGIN_MANIFEST_USER
git config --global user.email $PLUGIN_MANIFEST_USER_EMAIL
git add . && git commit --allow-empty -m "🚀 update to ${PLUGIN_IMAGE_TAG}"
git push $GIT_REPO_URI
