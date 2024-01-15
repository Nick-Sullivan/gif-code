
import boto3
from warrant.aws_srp import AWSSRP

ENV = "dev"

def main():
    secrets = load_secrets()

    aws = AWSSRP(
        username=secrets['USERNAME'],
        password=secrets['PASSWORD'],
        pool_id=secrets['POOL_ID'],
        client_id=secrets['CLIENT_ID'],
    )
    tokens = aws.authenticate_user()
    id_token = tokens['AuthenticationResult']['IdToken']
    refresh_token = tokens['AuthenticationResult']['RefreshToken']
    access_token = tokens['AuthenticationResult']['AccessToken']
    token_type = tokens['AuthenticationResult']['TokenType']

    print(f'id_token: {id_token}')


def load_secrets():
    secrets = {}
    prefix = f'/GifCode/{ENV.capitalize()}'
    parameter_names = {
        f'{prefix}/AutomatedTester/Username': 'USERNAME',
        f'{prefix}/AutomatedTester/Password': 'PASSWORD',
        f'{prefix}/Cognito/UserPoolId': 'POOL_ID',
        f'{prefix}/Cognito/ClientId': 'CLIENT_ID',
    }
    ssm_client = boto3.client('ssm')
    parameters = ssm_client.get_parameters(Names=list(parameter_names), WithDecryption=True)
    for parameter in parameters['Parameters']:
        secrets[parameter_names[parameter['Name']]] = parameter['Value']
    return secrets


if __name__ == '__main__':
    main()
