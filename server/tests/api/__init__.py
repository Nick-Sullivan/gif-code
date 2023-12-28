import os
import sys

import boto3
from dotenv import load_dotenv

os.environ['USE_LOCAL_INFRA'] = 'False'

sys.path.append('lambda/')
sys.path.append('lambda/layer/python/')

# If this is CICD, the environment to test is passed by environment variables.
# If this is local, the environment to test is in the root .env
is_cicd = os.environ.get('IS_CICD', 'False').lower() == 'true'
if not is_cicd:
    load_dotenv('.env')

env = os.environ['ENVIRONMENT']

prefix = f'/GifCode/{env.capitalize()}'
parameter_names = {
    f'{prefix}/ApiGateway/Url': 'API_GATEWAY_URL',
}
ssm_client = boto3.client('ssm')
parameters = ssm_client.get_parameters(Names=list(parameter_names), WithDecryption=True)
for parameter in parameters['Parameters']:
    os.environ[parameter_names[parameter['Name']]] = parameter['Value']
