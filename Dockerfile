# 正式打包
# 第一阶段
FROM python:3.11 as requirements-stage

WORKDIR /tmp
RUN pip install poetry
COPY ./pyproject.toml ./poetry.lock* /tmp/
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# 第二阶段
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11


# 工作目录
WORKDIR /app

# 安装依赖
COPY --from=requirements-stage /tmp/requirements.txt /app/requirements.txt
#RUN python -m pip install --upgrade pip -i https://pypi.douban.com/simple/ --trusted-host=pypi.douban.com/simple/
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt


# 拷贝代码
COPY ./app /app


# 创建相关目录
RUN mkdir -p /app/models \
    && mkdir -p /app/logs \
    && chmod 777 /app/logs

#ENV MYSQL_CONN = "111"
#VOLUME ["/app/app/models"]
#
#RUN chmod 777 /app/logs
#
## 声明容器内部监听的端口
#EXPOSE 8000
#
#RUN gunicorn --version
#
#CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
# 目前发现不能直接运行 gunicorn
# CMD ["gunicorn", "app.main:app", "-c", "gunicorn.conf.py"]
# CMD ["sh", "-c", "gunicorn app.main:app -c gunicorn.conf.py"]