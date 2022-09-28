#Jxwaf-Node
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


#日志配置
#https://docs.jxwaf.com/best-practice.html#%E9%83%A8%E7%


#Echo_Server
export Node_Name=Echo_Server
export Data_Path=/data/docker_${Node_Name}
export IMAGE_TAG=docker.io/huanwei/echoserver:1.8
docker pull ${IMAGE_TAG}

docker stop ${Node_Name} &>/dev/null
docker rm -f ${Node_Name} &>/dev/null

docker run -d --restart always --name ${Node_Name} --hostname ${Node_Name} \
    --cpus 2 --memory 4096m \
    --restart always --oom-kill-disable \
    --ulimit nofile=1048576:1048576 \
    --ulimit nproc=-1:-1 \
    --ulimit core=-1:-1 \
    --ulimit memlock=-1:-1 \
    -p 8090:8080 \
    -e TZ="Asia/Shanghai" \
    -v /dev:/dev:ro \
    -v /etc/localtime:/etc/localtime:ro \
${IMAGE_TAG}


#日志配置
#https://docs.jxwaf.com/best-practice.html#%E9%83%A8%E7%

