FROM openeuler/openeuler:23.09

RUN dnf update -y && \
    dnf install -y findutils wget zlib-devel bzip2-devel libffi-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make \
    && dnf clean all

# 安装 Python 3.12
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz && \
    tar -zxvf Python-3.12.3.tgz && \
    cd Python-3.12.3 && \
    ./configure --prefix=/usr/local/python3 --enable-optimizations --enable-shared &&\
    make && \
    make install

# 验证 Python 安装
RUN cp /usr/local/python3/lib/libpython3.12.so.1.0 /usr/lib64/ \
    && ln -s /usr/local/python3/bin/python3.12 /usr/bin/python3.12 \
    python3.12 --version

# 安装 Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
#RUN export PATH="/root/.local/bin:$PATH"` \
#    && poetry config virtualenvs.in-project true



# 设置环境变量
ENV PATH="/root/.local/bin:$PATH"

# 设置工作目录
WORKDIR /workspace

# 如果有需要，可以将代码复制到容器内
COPY . /workspace
