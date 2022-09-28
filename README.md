#Jxwaf docker

## jxwaf-server/ Jxwaf-manage DockerFile 
## jxwaf-node/ Jxwaf-node DockerFile
## 相关源码包

shell ```
curl -O -sfkL https://github.com/jx-sec/jxwaf-mini-server/archive/refs/tags/RC2.tar.gz
curl -O -sfkL https://github.com/jx-sec/jxwaf/archive/refs/tags/jxwaf2022-RC2.tar.gz
shell ```

### Jxwaf-Server
### 替换mysql数据库相关信息

shell ```
export Server_Port=8080
export Node_Name=Jxwaf-Server_Mysql
export Data_Path=/data/docker_${Node_Name}
export IMAGE_TAG=hub.wusong.com/library/devopsutilstools/jxwaf-server:v2022
docker pull ${IMAGE_TAG}
docker images ${IMAGE_TAG}
docker stop ${Node_Name} &>/dev/null
docker rm -f ${Node_Name} &>/dev/null

test ! -z ${Data_Path}&&test -e ${Data_Path}&&rm -rf ${Data_Path}

docker run -d --restart always --name ${Node_Name} --hostname ${Node_Name} \
    --cpus 2 --memory 4096m \
    --restart always --oom-kill-disable \
    --ulimit nofile=1048576:1048576 \
    --ulimit nproc=-1:-1 \
    --ulimit core=-1:-1 \
    --ulimit memlock=-1:-1 \
    --user root \
    -p ${Server_Port}:${Server_Port}/tcp \
    -e TZ="Asia/Shanghai" \
    -e DB_ENGINE="mysql" \
    -e DB_HOST="192.168.25.236" \
    -e DB_PORT="3306" \
    -e DB_NAME="jxwaf_db" \
    -e DB_USER="root" \
    -e DB_PASS="bUHvZJ9rzprE4dyzkJ0kkGw7EhRP3IprJ7yU9GmFZ5x3YOMogCMnnpqah0KoVbfJ" \
    -v /dev:/dev:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v ${Data_Path}/jxwaf-server:/opt/jxwaf-server \
${IMAGE_TAG}
```
### Jxwaf-Node
### 替换ENV_INIT相关信息 Jxwaf-manage 信息

shell ```

export Node_Name=Jxwaf-Node
export Data_Path=/data/docker_${Node_Name}
export IMAGE_TAG=hub.wusong.com/library/devopsutilstools/jxwaf-node:v2022
docker pull ${IMAGE_TAG}

docker stop ${Node_Name} &>/dev/null
docker rm -f ${Node_Name} &>/dev/null

test ! -z ${Data_Path}&&test -e ${Data_Path}&&rm -rf ${Data_Path}

docker run -d --restart always --name ${Node_Name} --hostname ${Node_Name} \
    --cpus 2 --memory 4096m \
    --restart always --oom-kill-disable \
    --ulimit nofile=1048576:1048576 \
    --ulimit nproc=-1:-1 \
    --ulimit core=-1:-1 \
    --ulimit memlock=-1:-1 \
    --network host \
    -e TZ="Asia/Shanghai" \
    -e ENV_INIT="--api_key=46756f17-42cb-48c7-ba66-7214a4061e10 --api_password=67e4643b-eb9c-49d2-85d6-1c9ef91d4605 --waf_server=http://192.168.25.47:8080" \
    -v /dev:/dev:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v ${Data_Path}/jxwaf:/opt/jxwaf \
${IMAGE_TAG}
shell ```
