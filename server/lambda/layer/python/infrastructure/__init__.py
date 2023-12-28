import os

import boto3

from .s3_interactor import S3Interactor

s3_interactor = S3Interactor(boto3.client('s3'), os.environ['S3_BUCKET_NAME'])
