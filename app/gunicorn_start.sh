#!/bin/bash

NAME=fastapi-sample
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

exec gunicorn app.main:app \
  --name $NAME \
  --workers $WORKERS \
  --worker-class $WORKER_CLASS \
  --user=$USER \
  --group=$GROUP \
  --bind=$BIND \
  --log-level=$LOG_LEVEL \
  --log-file=-