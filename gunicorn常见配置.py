#!/user/bin/env python3
# -*- coding: utf-8 -*-

debug = True
# 修改代码时自动重启
reload = True
#
reload_engine = 'inotify'

# 监听内网端口 绑定与Nginx通信的端口
bind = '127.0.0.1:8000'
# bind = 'unix:/programs/program-files/zy.ai/gunicorn.py.sock'

# 工作目录
chdir = './'

# 并行工作进程数
workers = 4

# 指定每个工作者的线程数
threads = 4

# 监听队列
backlog = 512

# 超时时间
timeout = 120

# 守护进程"（daemon）指的是将进程运行在后台的模式。简单来说，设置守护进程为 True 会使 Gunicorn 以后台进程的方式运行，
# 通常不依赖于终端或用户的会话。守护进程在后台执行，不会直接与用户交互。
# 适用场景: 适合那些不需要与终端交互的环境，例如生产环境。
# 测试则需要将此改为: False
daemon = True

# 工作模式协程
worker_class = 'uvicorn.workers.UvicornWorker'

# 设置最大并发量
worker_connections = 2000

# 设置进程文件目录
pidfile = './logs/gunicorn.py.pid'

# 设置访问日志和错误信息日志路径
accesslog = './logs/gunicorn_access.log'
errorlog = './logs/gunicorn_error.log'

# # 如果supervisor管理gunicorn
# errorlog = '-'
# accesslog = '-'

# 设置gunicron访问日志格式，错误日志无法设置
access_log_format = '%(h) -  %(t)s - %(u)s - %(s)s %(H)s'

# 设置这个值为true 才会把打印信息记录到错误日志里
capture_output = True

# 设置日志记录水平
loglevel = 'debug'

# # python程序
# pythonpath = '/programs/program-files/zy.ai/.venv/lib/python3.12/site-packages'


# pstree -ap|grep gunicorn.py

# 执行命令
# gunicorn.py -c gunicorn.py.conf.py shllm.main:app
# gunicorn.py -c gunicorn.py.conf.py shllm.main:app -k uvicorn.workers.UvicornWorker

# 自动执行
# 使用 supervisor
# https://docs.gunicorn.org/en/stable/deploy.html#supervisor
# 参考资料：
# https://www.jianshu.com/p/bbd0b4cfcac9
# https://www.cnblogs.com/tk091/archive/2014/07/22/3859514.html


