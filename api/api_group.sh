#!/usr/bin/env bash
#JxWaf Add Group Domain Api By:liuwei Mail:al6008@163.com
#通过group 统一配置 降低配置难度。

export Waf_Url=http://192.168.25.47:8080
export User_Cookice="sessionid=uib2ajc5njdw7b82l5ixymm8936x15fk"

export Waf_Domain=echo-test.wusong.com
export Source_IP="192.168.25.99"
export Source_Http_Port="8090"
export Group_UUID="b1c05494-1d31-4332-a418-77421cbc09e5"

#增加域名
curl -X POST \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H "Cookie: ${User_Cookice}" \
  -d "{
    \"source_http_port\": \"${Source_Http_Port}\",
    \"proxy_pass_https\": \"false\",
    \"redirect_https\": \"true\",
    \"checkListProtocol\": [
        \"HTTPS\",
        \"HTTP\"
    ],
    \"domain\": \"${Waf_Domain}\",
    \"ssl_domain\": \"*.wusong.com\",
    \"group_id\": \"${Group_UUID}\",
    \"ssl_source\": \"ssl_manage\",
    \"public_key\": \"\",
    \"private_key\": \"\",
    \"source_ip\": \"${Source_IP}\",
    \"http\": \"true\",
    \"https\": \"true\"
}" ${Waf_Url}/waf/waf_create_group_domain
exit 0
