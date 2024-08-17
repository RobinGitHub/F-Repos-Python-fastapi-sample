#!/user/bin/env python3
# -*- coding: utf-8 -*-
import os

import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_main():
    return {"msg": "Hello World1"}


if __name__ == '__main__':
    BASE_DIR = os.path.dirname(__file__)
    os.chdir(BASE_DIR)
    host = os.getenv("host", "0.0.0.0")
    port = os.getenv("port", 8000)
    uvicorn.run("main:app", host=host, port=port, log_level="info")
