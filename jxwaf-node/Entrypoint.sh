#!/usr/bin/env bash
#jxwaf-node start scripts By:liuwei Mail:al6008@163.com
source /etc/profile &>/dev/null
export ENV_INIT=${ENV_INIT:-"--api_key=f5d9b88d-1d4e-4c2c-9fb1-2aec2e1fce76 --api_password=247598f0-a80e-48a1-b506-181e4364b57c --waf_server=http://192.168.25.47:8080"}
#init dir
/tmp/chowndir -R app:app /opt/ &>/dev/null
/tmp/chowndir -R app:app /tmp/chowndir &>/dev/null
rm -rf /tmp/chowndir &>/dev/null

#init node
if [ ! -e "/opt/jxwaf/.init" ];then
   mkdir -p /opt/jxwaf/ 
   tar xf /usr/local/jxwaf.tar.gz  -C /opt/jxwaf/ 
   echo python2 /usr/local/jxwaf_init.py ${ENV_INIT}
   python2 /usr/local/jxwaf_init.py ${ENV_INIT}
   #python2 /usr/local/jxwaf_init.py --api_key=f5d9b88d-1d4e-4c2c-9fb1-2aec2e1fce76 --api_password=247598f0-a80e-48a1-b506-181e4364b57c --waf_server=http://192.168.25.47:8080
   touch /opt/jxwaf/.init
   echo "/opt/jxwaf/nginx/conf/jxwaf/jxwaf_config.json"
fi

#start
cd /opt/jxwaf/
exec /opt/jxwaf/nginx/sbin/nginx  -g "daemon off;" &&exit 0
exit 1
