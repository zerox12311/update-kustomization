#!/bin/sh
apk update && apk add --no-cache git && apk add --no-cache openssh
if [ -z "$SSH_KEY" ]
then
    mkdir -p ~/.ssh && echo $SSH_KEY | base64 -d > ~/.ssh/id_rsa && chmod 700 ~/.ssh/id_rsa && ssh-keyscan $MANIFEST_HOST >> ~/.ssh/known_hosts
    GIT_REPO_URI="ssh://git@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git"
else
    GIT_REPO_URI="https://$GIT_TOKEN@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git"
fi

rm -rf $MANIFEST_REPO && git clone $GIT_REPO_URI

cd $MANIFEST_REPO
git checkout $MANIFEST_BRANCH
cd $KUSTOMIZATION

for IMAGE in $(echo $IMAGES | sed "s/,/ /g")
do
    kustomize edit set image $IMAGE:$IMAGE_TAG
done

git config --global user.name $MANIFEST_USER
git config --global user.email $MANIFEST_USER_EMAIL
git add . && git commit --allow-empty -m "🚀 update to ${IMAGE_TAG}"
git push $GIT_REPO_URI
