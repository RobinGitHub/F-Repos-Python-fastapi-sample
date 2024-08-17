# 正式打包
# 第一阶段
FROM tiangolo/uvicorn-gunicorn:python3.11 as requirements-stage

WORKDIR /tmp
RUN pip install poetry
COPY ./pyproject.toml ./poetry.lock* /tmp/
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# 第二阶段
FROM tiangolo/uvicorn-gunicorn:python3.11

# 工作目录
WORKDIR /code

# 安装依赖
COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt
#RUN python -m pip install --upgrade pip -i https://pypi.douban.com/simple/ --trusted-host=pypi.douban.com/simple/
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


# 拷贝代码
COPY ./ /code/

ENV MYSQL_CONN = "111"

RUN mkdir -p /code/fastapi_sample/models
VOLUME ["/code/fastapi_sample/models"]

# 声明容器内部监听的端口
EXPOSE 8000

CMD ["uvicorn", "fastapi_sample.main:app", "--host", "0.0.0.0", "--port", "8000"]