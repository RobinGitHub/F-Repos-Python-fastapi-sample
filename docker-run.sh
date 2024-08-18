docker run -itd --restart=always \
 --name fastapi-sample \
 -p 8000:8000 \
 -v F:/Repos/Python/fastapi-sample/app/models:/code/app/models \
 fastapi-sample:1.0.0


docker run -itd -e TZ="Asia/Shanghai" --restart=always --name fastapi-sample -p 8000:8000 fastapi-sample:1.0.0

# docker run -d -p 8000:8000 -v $(pwd):/app fastapi-sample:1.0.0
docker run -d -p 8000:8000 -v F:/Repos/Python/fastapi-sample/docker-test:/app fastapi-sample:1.0.0

docker run -d -p 8000:8000 fastapi-sample:1.0.0

docker run -d --name fastapi-sample -p 8000:8000 -e ERROR_LOG="./logs/gunicorn_error.log" -e ACCESS_LOG="./logs/gunicorn_access.log" -v F:/Repos/Python/fastapi-sample/docker-test:/app  fastapi-sample:1.0.0

docker run -d --name fastapi-sample -p 8000:8000 -v F:/Repos/Python/fastapi-sample/docker-test/models:/app/models  fastapi-sample:1.0.0

# window 中运行
docker run -d --name fastapi-sample -p 8000:8000 -v ${PWD}/models:/app/models  fastapi-sample:1.0.0

# linxu 中运行

