#!/usr/bin/env bash
#JxWaf Add Domain Api By:liuwei Mail:al6008@163.com

export Waf_Url=http://192.168.25.47:8080
export User_Cookice="sessionid=r24y8dfcrhl3ibu9sxv1lbraazx18dxs"

export Waf_Domain=echo-test.wusong.com
export Source_IP="192.168.25.99"
export Source_Http_Port="8090"
#增加域名
curl -X POST \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H "Cookie: ${User_Cookice}" \
  -d "{
    \"source_http_port\": \"${Source_Http_Port}\",
    \"proxy_pass_https\": \"false\",
    \"checkListProtocol\": [
        \"HTTP\",
        \"HTTPS\"
    ],
    \"domain\": \"${Waf_Domain}\",
    \"ssl_domain\": \"*.wusong.com\",
    \"ssl_source\": \"ssl_manage\",
    \"public_key\": \"\",
    \"private_key\": \"\",
    \"source_ip\": \"${Source_IP}\",
    \"http\": \"true\",
    \"https\": \"true\"
}" ${Waf_Url}/waf/waf_create_domain 


#配置防护规则
sleep 3
curl -X POST \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H "Cookie: ${User_Cookice}" \
  -d "{
    \"flow_rule_protection\": \"true\",
    \"domain\": \"${Waf_Domain}\",
    \"web_white_rule\": \"true\",
    \"web_engine_protection\": \"true\",
    \"web_rule_protection\": \"true\",
    \"name_list\": \"true\",
    \"flow_deny_page\": \"false\",
    \"web_deny_page\": \"true\",
    \"flow_white_rule\": \"true\",
    \"flow_engine_protection\": \"true\"
}" ${Waf_Url}/waf/waf_edit_protection

#配置CC攻击规则
curl -X POST \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H "Cookie: ${User_Cookice}" \
  -d "{
    \"domain\": \"${Waf_Domain}\"
}" ${Waf_Url}/waf/waf_get_flow_engine_protection
sleep 3
curl -X POST \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H "Cookie: ${User_Cookice}" \
  -d "{
    \"ip_count_block_mode_extra_parameter\": \"standard\",
    \"slow_cc_check\": \"true\",
    \"emergency_mode_check\": \"false\",
    \"slow_cc_block_mode\": \"block\",
    \"req_count_stat_time_period\": \"60\",
    \"req_count_block_mode\": \"block\",
    \"req_count\": \"1000\",
    \"emergency_mode_block_mode_extra_parameter\": \"standard\",
    \"ip_count_block_mode\": \"block\",
    \"req_rate_block_mode\": \"block\",
    \"slow_cc_block_mode_extra_parameter\": \"standard\",
    \"domain_rate\": \"3000\",
    \"ip_count\": \"200\",
    \"req_rate\": \"60\",
    \"ip_count_stat_time_period\": \"60\",
    \"high_freq_cc_check\": \"true\",
    \"emergency_mode_block_mode\": \"block\",
    \"req_rate_block_mode_extra_parameter\": \"standard\",
    \"req_count_block_mode_extra_parameter\": \"standard\",
    \"domain\": \"${Waf_Domain}\"
}" ${Waf_Url}/waf/waf_edit_flow_engine_protection
exit 0
