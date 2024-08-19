#!/user/bin/env python3
# -*- coding: utf-8 -*-

from sqlmodel import SQLModel, Field


class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(max_length=100)
    age: int = Field(default=0)
