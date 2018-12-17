from __future__ import print_function
from datetime import datetime
import json
import boto3
from botocore.exceptions import ClientError
import os


def lambda_handler(event, context):
  try:
    client_dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")
    table = client_dynamodb.Table('Dates')
    response = table.put_item(Item={'date': {'S': unicode(datetime.datetime.now()) }})
    return response

  except  ClientError as e:
    print(e)

  except Exception as ex:
    print(ex)


