[toc]

# 项目结构


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
4. 启动项目 ```sudo docker run -d --restart=always --name fastapi-sample fastapi-sample:1.0.0 -e host=0.q0.0.0 port=8000 mysl_url=mysql+pymysql://root:123456@192.168.5.102:3306/shllm MODELS_PATH=./models  ```

## 参考资料
https://www.cnblogs.com/pearlcity/p/16635569.html


# 发布到Linux


## 常用命令


# 注意事项
