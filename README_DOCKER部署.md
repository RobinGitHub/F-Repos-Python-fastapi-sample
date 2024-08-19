# 必看

1. 先看 https://github.com/tiangolo/uvicorn-gunicorn-docker
2. 再看 https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker
3. 项目模板 https://github.com/fastapi/full-stack-fastapi-template



# 项目说明

初步结论：

1. 目前项目基于poetry 创建
2. 项目对应的包名应改为app
3. 后续所有的开发文件都应在app包下；因基于docker发布时，内置的默认逻辑是用的app
4. https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker => Development live reload  
   支持开发过程实时调试镜像



[toc]

# Dockerfile

```shell
https://blog.csdn.net/m0_74738450/article/details/135394803
https://blog.csdn.net/KQe397773106/article/details/137744478

1. 生成镜像 ```docker build --no-cache -t zy.ai:1.0.0 .```
2. 导出镜像 ```docker export 镜像id > zy.ai.tar```
3. 导入本地镜像 ```sudo docker import zy.ai < zy.ai.tart```
4. 启动项目 ```sudo docker run -d --restart=always --name zy.ai zy.ai:1.0.0 -e host=0.q0.0.0 port=8000 mysl_url=mysql+pymysql://root:123456@192.168.5.102:3306/shllm MODELS_PATH=./models  ```
```



## 数据库迁移

```shell
# 项目初始化时
alembic init alembic

# 产生迁移
alembic revision --autogenerate -m "init"

# 执行迁移
alembic upgrade head
```

## 开放端口

```shell
7017 服务端
7018 网页端
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload 
```




# 常用命令

## Python

> 导出安装包为requirements.txt的方式  
> ``` pip freeze > requirements.txt```

> 下载离线安装包放到当前文件夹的packs文件夹中  
> ```pip download -d ./packs -r requirements.txt```

> 复制requirements.txt和packs文件夹到另一台电脑上使用命令离线安装  
> ```pip install --no-index --find-links=packs -r requirements.txt```

## pip

```shell
# 生成requirements.txt
pipreqs --force ./
```

## Poetry

> 导出为离线包

``` python
poetry self add poetry-plugin-export
poetry export -f requirements.txt --without-hashes --output requirements.txt
mkdir -p packages
pip download -r requirements.txt -d packages
```

## Docker 

```shell
进入容器：docker exec -it a6fe8d12febc /bin/bash
查看容器：docker ps -a
查看日志：docker logs c7ffe3c212c2
查看镜像：docker images
删除容器：docker rm 60a643861c76
删除镜像：docker rmi 60a643861c76
运行容器：docker run -itd -e TZ="Asia/Shanghai" --restart=always --name V2-fastapi -p 9001:9001 
-v /yunhuoV2/fastapi/code:/app xy-fastapi:2.0 /bin/bash
运行容器：docker run -itd -e TZ="Asia/Shanghai" --restart=always --name V2-fastapi -p 9001:9001 
-v /yunhuoV2/fastapi/code:/app xy-fastapi:2.0 /bin/bash 
-c "gunicorn main:app -k uvicorn.workers.UvicornWorker -c gunicorn.conf.py"
拷贝文件：docker cp dos.sh e1cd43c4f0a5:/code
生成镜像：docker build -f fastapi_dockerfile_v1 -t xy-fastapi:2.0 .
```

