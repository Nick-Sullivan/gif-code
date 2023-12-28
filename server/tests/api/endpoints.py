
import json
import os

import requests

base_url = os.environ['API_GATEWAY_URL']


def _post(endpoint, data):
    return requests.request(
        'POST',
        f'{base_url}/{endpoint}',
        data=json.dumps(data))


def create(request):
    return _post('gif', request)


def get_image(presigned_url: str):
    return requests.get(presigned_url)
    