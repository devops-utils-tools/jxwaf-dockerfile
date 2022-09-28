#!/bin/bash
#Docker Build Image By:liuwei Mail:al6008@163.com
#docker pull debian:stretch-slime
export VERSION=${1:-"v2022"}
export IMAGE_TAG=devopsutilstools/jxwaf-node:${VERSION}

export HUB_LISTS="hub.wusong.com hub.hqzhixing.com"
#docker rmi ${IMAGE_TAG}
#docker build --no-cache -t ${IMAGE_TAG} ./
docker build --compress --build-arg VERSION=${VERSION} -t ${IMAGE_TAG} ./

for hub in ${HUB_LISTS}
do
    docker tag ${IMAGE_TAG} ${hub}/library/${IMAGE_TAG}
    echo ${hub}/library/${IMAGE_TAG}
    docker push ${hub}/library/${IMAGE_TAG}

done
docker push ${IMAGE_TAG} &&exit 0
exit 1
