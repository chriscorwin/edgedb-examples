/*
##### Translate this function  from Python into JavaScript
### Python
# fastapi-crud/app/users.py
from __future__ import annotations

import datetime
from http import HTTPStatus
from typing import Iterable

import edgedb
from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel

router = APIRouter()
client = edgedb.create_async_client()


class RequestData(BaseModel):
    name: str


class ResponseData(BaseModel):
    name: str
    created_at: datetime.datetime


@router.get("/users")
async def get_users(
    name: str = Query(None, max_length=50)
    ) -> Iterable[ResponseData]:

    if not name:
        users = await client.query(
            "SELECT User {name, created_at};"
            )
    else:
        users = await client.query(
        """SELECT User {name, created_at}
            FILTER User.name = <str>$name""",
            name=name,
        )
    response = (
        ResponseData(
            name=user.name,
            created_at=user.created_at
        ) for user in users
    )
    return response
*/
// ### Javascript
// fastapi-crud/app/users.js
import { Router } from "express";
import { createAsyncClient } from "edgedb";

const router = Router();
const client = createAsyncClient();

router.get("/users", async (req, res) => {
  const { name } = req.query;
  let users;
  if (!name) {
    users = await client.query(`
      SELECT User {
        name,
        created_at
      };
    `);
  } else {
    users = await client.query(`
      SELECT User {
        name,
        created_at
      }
      FILTER User.name = <str>$name;
    `, { name });
  }
  const response = users.map(user => ({
    name: user.name,
    created_at: user.created_at
  }));
  res.send(response);
});

export default router;

