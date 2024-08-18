[toc]

# 项目说明

1. 先看 https://github.com/tiangolo/uvicorn-gunicorn-docker
2. 再看 https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker

初步结论：
1. 目前项目基于poetry 创建
2. 项目对应的包名应改为app
3. 后续所有的开发文件都应在app包下；因基于docker发布时，内置的默认逻辑是用的app
4. https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker => Development live reload  
   支持开发过程实时调试镜像


# 项目结构



## 文档参考
- https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker
- https://github.com/tiangolo/uvicorn-gunicorn-docker/blob/master/scripts/process_all.py





# Python

> 导出安装包为requirements.txt的方式  
  ``` pip freeze > requirements.txt```

> 下载离线安装包放到当前文件夹的packs文件夹中  
  ```pip download -d ./packs -r requirements.txt```

> 复制requirements.txt和packs文件夹到另一台电脑上使用命令离线安装  
  ```pip install --no-index --find-links=packs -r requirements.txt```


# Poetry

>导出为离线包
``` python
poetry self add poetry-plugin-export
poetry export -f requirements.txt --without-hashes --output requirements.txt
mkdir -p packages
pip download -r requirements.txt -d packages
```


# devcontainer 说明

1. 只适合于开发时使用
2. 


# Docker 部署

> 第一阶段导出依赖文件，第二阶段可以引用第一阶段的结果，进行安装依赖

1. 生成镜像 ```docker build --no-cache -t fastapi-sample:1.0.0 .```
2. 导出镜像 ```docker export 镜像id > fastapi-sample.tar```
3. 导入本地镜像 ```sudo docker import fastapi-sample < fastapi-sample.tart```
4. 启动项目 
   ```shell
    # 指定卷轴在windows中要用绝对路径，linux 中用 $(pwd)
    docker run -itd --restart=always \
     --name fastapi-sample \
     -p 8000:8000 \
     -v F:/Repos/Python/fastapi-sample/app/models:/code/app/models \
     fastapi-sample:1.0.0
   ```

## 参考资料
https://www.cnblogs.com/pearlcity/p/16635569.html
https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker


# 发布到Linux

## TODO
- https://dylancastillo.co/posts/fastapi-nginx-gunicorn.html
- https://fastapitutorial.com/blog/deploying-fastapi-with-gunicorn-nginx-certbot/
- https://medium.com/@kevinzeladacl/deploy-a-fastapi-app-with-nginx-and-gunicorn-b66ac14cdf5a


## 常用命令


# 注意事项
