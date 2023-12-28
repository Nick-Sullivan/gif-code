"""Hosts API endpoints locally"""

import json
import os
import sys
from base64 import b64encode
from io import BytesIO
from typing import Any, Dict

import boto3
import uvicorn
from dotenv import load_dotenv
from fastapi import Body, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.requests import Request

sys.path.append('lambda/')
sys.path.append('lambda/layer/python/')


app = FastAPI(title="QifCode")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


@app.post("/gif")
async def create_qr_gif(request: Request):
    body = await request.json()
    import handler.create_qr_gif as module
    response = invoke(module.create_qr_gif, body)
    return response


def invoke(func, body: Dict, pathParams=None):
    event = {
        'body': json.dumps(body),
        'pathParameters': pathParams,
    }
    response = func(event)
    if response['statusCode'] == 200:
        if 'body' in response:
            return json.loads(response['body'])
    else:
        raise HTTPException(status_code=response['statusCode'], detail=json.loads(response['body']))


def load_parameters():
    load_dotenv('../.env')

    env = os.environ['ENVIRONMENT'].upper()

    prefix = f'/GifCode/{env.capitalize()}'
    names = {
        f'{prefix}/S3/Name': 'S3_BUCKET_NAME',
    }
    ssm_client = boto3.client('ssm')
    parameters = ssm_client.get_parameters(Names=list(names), WithDecryption=True)
    for parameter in parameters['Parameters']:
        os.environ[names[parameter['Name']]] = parameter['Value']


if __name__ == "__main__":
    load_parameters()
    uvicorn.run(app, host="127.0.0.1", port=8000)
