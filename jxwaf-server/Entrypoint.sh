#!/usr/bin/env bash
#jxwaf-server start scripts By:liuwei Mail:al6008@163.com
source /etc/profile &>/dev/null

#数据库初始化
mysql_db_init(){
echo ----------------------------------------------- init db -----------------------------------------------
/usr/local/mysql-client/bin/mysql -u${DB_USER} -h${DB_HOST} -P ${DB_PORT} --password="${DB_PASS}" -e "\
    create database if not exists ${DB_NAME} DEFAULT CHARSET utf8 COLLATE utf8_general_ci; \
    use ${DB_NAME}; \
    show tables; \
    " 2>/dev/null
echo -------------------------------------------------------------------------------------------------------
}

#jxwaf config
jxwafconfig(){
touch /opt/jxwaf-server/jxwaf_min_server/settings.py
cp /opt/jxwaf-server/jxwaf_min_server/settings.py  /opt/jxwaf-server/jxwaf_min_server/settings.py.default
cat > /opt/jxwaf-server/jxwaf_min_server/settings.py <<EOF
import os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEBUG = True
SECRET_KEY = 'yi538!me3^x)^n#v1l6^mim+hp=m\$5wd89d-p!(-23ge65=ry%'
ALLOWED_HOSTS = ["0.0.0.0/0"]
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'server.apps.ServerConfig',
]
MIDDLEWARE_CLASSES = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
]
ROOT_URLCONF = 'jxwaf_min_server.urls'
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')]
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
WSGI_APPLICATION = 'jxwaf_min_server.wsgi.application'

$(if [[ "${DB_ENGINE:-"sqlite3"}" != "mysql" ]];then
    echo "DATABASES = {"
    echo "  'default': {"
    echo "   'ENGINE': 'django.db.backends.sqlite3',"
    echo "   'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),"
    echo "    }"
    echo "}"
else
    echo "DATABASES = {"
    echo "    'default': {"
    echo "        'ENGINE': 'django.db.backends.mysql',"
    echo "        'NAME': '${DB_NAME:-"jxwaf_db"}',"
    echo "        'USER': '${DB_USER:-"jxwaf_user"}',"
    echo "        'PASSWORD': '${DB_PASS:-"jxwaf_pass"}',"
    echo "        'HOST': '${DB_HOST:-"127.0.0.1"}',"
    echo "        'PORT': '${DB_PORT:-"3306"}',"
    echo "    }"
    echo "}"
fi)

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]
LANGUAGE_CODE = 'en-us'
USE_TZ = False
TIME_ZONE = 'Asia/Shanghai'
STATIC_ROOT = "static/"
STATIC_URL = '/static/'
JXWAF_SYS_VERSION = '20220831'
EOF
}

#init dir
/tmp/chowndir -R app:app /opt/ &>/dev/null
/tmp/chowndir -R app:app /tmp/chowndir &>/dev/null
rm -rf /tmp/chowndir &>/dev/null

#init server
if [ ! -e "/opt/jxwaf-server/.init" ];then
    cp -a /usr/local/jxwaf-server /opt/
    cd /opt/jxwaf-server
    jxwafconfig
    touch /opt/jxwaf-server/.init

    #初始化数据库
    if [[ "${DB_ENGINE:-"sqlite3"}" == "mysql" ]];then
        #mysql初始化
        #判断用户是否存在 没有存在初始化mysql数据库
        export User_Count=$(/usr/local/mysql-client/bin/mysql -u${DB_USER} -h${DB_HOST} -P ${DB_PORT} --skip-column-names --silent --raw  --password="${DB_PASS}" -e "\
            SELECT COUNT(*) FROM ${DB_NAME}.server_jxwaf_user;\
            " 2>/dev/null)
        if [ "${User_Count}" -lt 1 ];then
            echo "mysql db init"
            mysql_db_init;
            python2 manage.py makemigrations
            python2 manage.py migrate
        fi
    else
        #sqlite3 初始化
        echo "sqlite3 db init"
        python2 manage.py makemigrations
        python2 manage.py migrate
    fi


fi

#start
cd /opt/jxwaf-server
exec python2 manage.py runserver 0.0.0.0:8080 &&exit 0
exit 1
