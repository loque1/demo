from chalice import Chalice
from datetime import datetime
import json
import boto3
from botocore.exceptions import ClientError
import os


app = Chalice(app_name='updatedb')

@app.lambda_function()
def updatedb(event, context):
  try:
    client_dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")
    table = client_dynamodb.Table('Dates')
    response = table.put_item(Item={'date': {'S': unicode(datetime.datetime.now()) }})
    return response

  except  ClientError as e:
    print(e)

  except Exception as ex:
    print(ex)

@app.route('/update', methods=['POST'])
def updatedb():
  try:
    client_dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")
    table = client_dynamodb.Table('Dates')
    response = table.put_item(Item={'date': {'S': unicode(datetime.datetime.now()) }})
    return response

  except  ClientError as e:
    print(e)

  except Exception as ex:



@app.route('/')
def index():

    return {}


# The view function above will return {"hello": "world"}
# whenever you make an HTTP GET request to '/'.
#
# Here are a few more examples:
#
# @app.route('/hello/{name}')
# def hello_name(name):
#    # '/hello/james' -> {"hello": "james"}
#    return {'hello': name}
#
# @app.route('/users', methods=['POST'])
# def create_user():
#     # This is the JSON body the user sent in their POST request.
#     user_as_json = app.current_request.json_body
#     # We'll echo the json body back to the user in a 'user' key.
#     return {'user': user_as_json}
#
# See the README documentation for more examples.
#
