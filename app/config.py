#!/user/bin/env python3
# -*- coding: utf-8 -*-
import os


class Settings:
    SQLALCHEMY_DATABASE_URI: str = os.getenv("mysql_url", "mysql+pymysql://root:123456@192.168.2.100:3306/test")


settings = Settings()
