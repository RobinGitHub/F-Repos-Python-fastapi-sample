docker run -itd -e TZ="Asia/Shanghai" --restart=always --name fastapi-sample -p 8000:8000 -v F:\Repos\Python\fastapi-sample\fastapi_sample\models:/code/fastapi_sample/models fastapi-sample:1.0.0 /bin/bash -c "gunicorn fastapi_sample.main:app -k uvicorn.workers.UvicornWorker -c gunicorn.py"



docker run -itd -e TZ="Asia/Shanghai" --restart=always --name fastapi-sample -p 9000:8000 fastapi-sample:1.0.0 /bin/bash -c "gunicorn fastapi_sample.main:app -k uvicorn.workers.UvicornWorker -c gunicorn.py"