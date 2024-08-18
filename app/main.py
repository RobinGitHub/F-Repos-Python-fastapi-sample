#!/user/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys

import uvicorn
from fastapi import FastAPI

version = f"{sys.version_info.major}.{sys.version_info.minor}"

app = FastAPI()


@app.get("/")
async def read_main():
    return {"msg": "Hello World1222"}


@app.get("/test")
async def read_root():
    message = f"Hello world! From FastAPI running on Uvicorn with Gunicorn. Using Python {version}"
    return {"message": message}


if __name__ == '__main__':
    BASE_DIR = os.path.dirname(__file__)
    os.chdir(BASE_DIR)
    host = os.getenv("host", "0.0.0.0")
    port = os.getenv("port", 8000)
    uvicorn.run("app.main:app", host=host, port=port, log_level="info")
