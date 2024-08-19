**部署服务器：** *openEuler 23.09*  

**查看系统信息：**```cat /etc/os-release```

**部署方式：** FastAPI + [NGINX](https://www.nginx.com/)  + [Gunicorn](https://gunicorn.org/) +  [Uvicorn](https://www.uvicorn.org/) + [supervisor](http://supervisord.org/running.html?highlight=reread)

**参考：**

- 主要：https://dylancastillo.co/posts/fastapi-nginx-gunicorn.html#configure-supervisor
- https://dylancastillo.co/posts/fastapi-nginx-gunicorn.html
- https://fastapitutorial.com/blog/deploying-fastapi-with-gunicorn-nginx-certbot/
- https://medium.com/@kevinzeladacl/deploy-a-fastapi-app-with-nginx-and-gunicorn-b66ac14cdf5a



[toc]

# 软件安装

## mysql 

https://www.cnblogs.com/eljxy/p/16893453.html

以此为准
https://blog.csdn.net/qq_24330181/article/details/124451848

采用最新的包源 https://repo.mysql.com/mysql84-community-release-el8-1.noarch.rpm

https://repo.mysql.com/

~~~shell
#清理 dnf 的缓存，以确保所有的包和元数据都是最新的：
sudo dnf clean all

yum -y update

# 查看日志
ssudo tail -n 50 /var/log/mysqld.log

dnf install https://repo.mysql.com/mysql84-community-release-el8-1.noarch.rpm
#然后，安装 MySQL 服务器：
sudo yum -y install mysql-community-server
sudo systemctl start mysqld
sudo systemctl status mysqld
sudo systemctl enable mysqld

#你可以通过查看 MySQL 的初始密码来完成进一步的设置：
sudo grep 'temporary password' /var/log/mysqld.log

# 登录
mysql -h localhost -uroot -p

# 修改密码并授权可以访问主机
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Lihaozhe!!@@1122';
FLUSH PRIVILEGES;

update mysql.user set host = '%' where user='root';
FLUSH PRIVILEGES;
# 退出mysql
exit;


#开放端口
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload 


# 使用新密码连接
mysql -h 你自己的IP地址 -uroot -p


#编辑配置文件修改服务器端字符集 在[mysqld]下面增加
vim /etc/my.cnf
character-set-server=utf8mb4

systemctl restart mysqld
~~~



## Python 3.12

> https://www.cnblogs.com/chrjiajia/p/17916490.html

### 前置准备

1. 检查是否已经安装Python3：命令行直接输入Python3
2. 下载Python3的安装包 https://www.python.org/ftp/python/

### 安装Python3.12

```shell
# 安装依赖
yum install zlib-devel bzip2-devel libffi-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

# 下载Python安装包
wget https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tgz

# 解压，编辑
tar -zxvf Python-3.11.2.tgz
cd Python-3.11.2
# 可以不加'--enable-optimizations'，加了容易报错，且安装时间长。
./configure --prefix=/usr/local/python3 --enable-optimizations --enable-shared --with-ssl
make && make install

# 添加软链并测试
ln -s /usr/local/python3/bin/python3.12 /usr/bin/python3.12
# 查看版本
python3 -V

# 运行时没加载到libpython3.12.so.1.0这个库文件
cp /usr/local/python3/lib/libpython3.12.so.1.0 /usr/lib64/

# 创建虚拟环境
python3.12 -m venv .venv
# 切换到虚拟环境
source .venv/bin/activate
# 退出虚拟环境
deactivate
```



## 安装supervisor

> 官网 http://supervisord.org/running.html?highlight=reread
>
> 参考 https://forum.openeuler.org/t/topic/5217

```shell
# 从 pip 安装
pip install supervisor
# 创建必要文件夹
mkdir -p /etc/supervisor/conf.d
mkdir -p /var/log/supervisor/

# Creating a Configuration File 创建配置文件
echo_supervisord_conf > /etc/supervisor/supervisord.conf

# supervisord.conf 的最后2行取消注释
[include]
files = /etc/supervisor/conf.d/*.conf
```

```shell
# 创建启动脚本
vi /etc/systemd/system/supervisor.service
# 填入
[Unit]
Description=Supervisor process control system for UNIX
Documentation=http://supervisord.org
After=network.target

[Service]
ExecStart=/usr/local/bin/supervisord -n -c /etc/supervisor/supervisord.conf
ExecStop=/usr/local/bin/supervisorctl $OPTIONS shutdown
ExecReload=/usr/local/bin/supervisorctl -c /etc/supervisor/supervisord.conf $OPTIONS reload
KillMode=process
Restart=on-failure
RestartSec=50s

[Install]
WantedBy=multi-user.target
```

```
# 启动服务
systemctl start supervisor.service
# 开机启动
systemctl enable supervisor.service
```
### 命令

> 参考：https://blog.csdn.net/yzlaitouzi/article/details/108531326

```shell
whereis supervisor

# 启动supervisor服务，命令为
sudo supervisord -c /etc/supervisor/supervisord.conf

# 查看supervisor服务是否正常运行，命令为
sudo supervisorctl

sudo supervisorctl shutdown
sudo supervisorctl reload

# 更新配置后必须执行更新命令才生效
sudo supervisorctl update

# 查看supervisor进程
sudo supervisorctl status

# 启动某个supervisor进程
sudo supervisorctl start xxxx
# 停止某个supervisor进程
sudo supervisorctl stop xxxx
# 停止所有supervisor进程
sudo supervisorctl stop all
# 重启某个supervisor进程
sudo supervisorctl restart xxxx
```



## NGINX

> 参考：https://blog.csdn.net/qq_42194420/article/details/123222008
>
> 官网：https://nginx.org/en/download.html
>
>  https://stackoverflow.com/questions/70111791/nginx-13-permission-denied-while-connecting-to-upstream

```shell
# 安装依赖
yum -y install pcre-devel openssl openssl-devel
# 下载最新版本nginx压缩包
wget https://nginx.org/download/nginx-1.26.2.tar.gz
# 解压
tar -zxvf nginx-1.26.2.tar.gz
cd nginx-1.26.2
./configure
make && make install

# 启动服务，检查运行情况
cd /usr/local/nginx/sbin/
./nginx
ps -ef | grep nginx

# 修改默认配置 user nginx 改为 root
/etc/nginx/nginx.conf

# 因是通过源码安装的，默认没有安装服务
systemctl start nginx.service
systemctl enable nginx.service
```
### 命令

```shell
systemctl start nginx.service
systemctl restart nginx.service
systemctl enable nginx.service

# 查找 Nginx 主进程的用户：
cat /etc/nginx/nginx.conf | grep '^user'
```

### 遇到的问题

1. Permission denied

   > In my case the default user was `www-data` and I changed it to my `root` machine username.
   >
   > https://stackoverflow.com/questions/70111791/nginx-13-permission-denied-while-connecting-to-upstream

2. 将nginx允许访问unix套接字

   ```shell
   sudo usermod -aG fastapi-user nginx
   ```

3. SELinux 策略限制

   ```shell
   # 临时放开
   sudo setenforce 0
   # 如果 SELinux 仍然阻止 Nginx 访问，考虑创建一个 SELinux 策略模块来允许这一操作。你可以使用 audit2allow 工具自动生成所需的策略模块：
   # 生成策略模块
   sudo audit2allow -a -M mynginxpolicy
   
   # 安装策略模块
   sudo semodule -i mynginxpolicy.pp
   # 验证并重新启动 Nginx
   sudo systemctl restart nginx
   ```

   


# 相关配置

## Gunicorn

> 项目根目录下 gunicorn_start.sh
```shell
#!/bin/bash
NAME=fastapi-app
DIR=/home/fastapi-user/app-0.1.0
USER=fastapi-user
GROUP=fastapi-user
WORKERS=3
WORKER_CLASS=uvicorn.workers.UvicornWorker
VENV=$DIR/.venv/bin/activate
BIND=unix:$DIR/gunicorn.sock
LOG_LEVEL=error

cd $DIR
source $VENV

exec gunicorn main:app \
  --name $NAME \
  --workers $WORKERS \
  --worker-class $WORKER_CLASS \
  --user=$USER \
  --group=$GROUP \
  --bind=$BIND \
  --log-level=$LOG_LEVEL \
  --log-file=-
  
或

exec gunicorn app.main:app -c gunicorn_conf.py
```



## Supervisor

> sudo vim /etc/supervisor/conf.d/fastapi-app.conf

```shell
[program:fastapi-app]
command=/home/fastapi-user/app-0.1.0/gunicorn_start.sh
user=fastapi-user
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/home/fastapi-user/app-0.1.0/logs/gunicorn-error.log

#将配置文件移至 /etc/supervisor/conf.d/
cp fastapi-app.conf /etc/supervisor/conf.d/

sudo supervisorctl reread
sudo supervisorctl update
# 查看状态
sudo supervisorctl status fastapi-app

# 查看服务是否正常启动
curl --unix-socket /home/fastapi-user/app-0.1.0/gunicorn.sock localhost

# 如果您对代码进行更改，则可以通过运行以下命令重新启动服务以应用更改
sudo supervisorctl restart fastapi-app
```



## NGINX

> 将配置文件移至 /etc/nginx/conf.d/
>
> cp fastapi-app.conf /etc/nginx/conf.d/

```shell
upstream app_server {
    server unix:/home/fastapi-user/gunicorn.sock fail_timeout=0;
}

server {
    listen 80;

    # add here the ip address of your server
    # or a domain pointing to that ip (like example.com or www.example.com)
    server_name XXXX;

    keepalive_timeout 5;
    client_max_body_size 4G;

    access_log /home/fastapi-user/logs/nginx-access.log;
    error_log /home/fastapi-user/logs/nginx-error.log;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        if (!-f $request_filename) {
            proxy_pass http://app_server;
            break;
        }
    }
}
# 修改完后重启
sudo systemctl restart nginx
```





# 项目打包

## 使用非root用户

```shell
# 基于 centos
sudo useradd fastapi-user # replace fastapi-user with your preferred name
sudo passwd fastapi-user # set the password for the new user
sudo usermod -aG wheel fastapi-user # add to sudoers group
su - fastapi-user # login as fastapi-user   
# 基于Ubuntu 在创建用户时，系统会提示你输入密码。
sudo adduser fastapi-user # replace fastapi-user with your preferred name
sudo gpasswd -a fastapi-user sudo # add to sudoers
su - fastapi-user # login as fastapi-user

# 修改当前密码
passwd
```

```shell
Poetry Build # 会产生 app-0.1.0.tar.gz & app-0.1.0-py3-none-any.whl
# 将2个文件拷贝到服务器
# 解压
tar -zxvf archive.tar.gz -C /path/to/destination
unzip 文件名.zip -d 目标目录

cd /home/fastapi-user/app-0.1.0
python3.11 -m venv .venv
source .venv/bin/activate
# 安装依赖，需联网
pip install shllm-0.1.0-py3-none-any.whl
```

## 启动项目

```shell
# 手动创建数据库 
create database shllm;

#手动执行数据迁移 
# 注意：一定要在项目根目录执行
alembic upgrade head

uvicorn app.main:app
# 验证是否正常
curl http://localhost:8000
```



# 常用命令

## 防火墙

```shell
sudo firewall-cmd --state
sudo firewall-cmd --zone=public --add-service=ssh --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl stop firewalld
sudo systemctl disable firewalld
```





