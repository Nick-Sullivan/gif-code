import json
import math
import time
from base64 import b64encode
from typing import Dict

from domain_models.exceptions import InvalidRequestException
from domain_models.image import ColorMode
from domain_models.requests import CreateQrRequest
from domain_models.validation import validate_request
from domain_services import gif_maker, qr_builder, qr_gif_combiner
from infrastructure import s3_interactor
from PIL import Image


def create_qr_gif(event, context=None):
    print(event['body'])
    body = json.loads(event['body'])
    response = _create_qr_gif(body)
    return {
        'statusCode': 200,
        'headers': { 'Content-Type': 'application/json'},
        'body': json.dumps(response),
    }
 

def _create_qr_gif(request_body: Dict) -> Image:
    start = time.time()

    print(f'{time.time() - start:.2f} Populating request')
    request_body = _fill_defaults(request_body)
    error_msgs = validate_request(request_body, CreateQrRequest)
    if error_msgs:
        raise InvalidRequestException(json.dumps({'errors': error_msgs}))
    request_body = _populate_enums(request_body)
    request = CreateQrRequest(**request_body)
        
    print(f'{time.time() - start:.2f} Creating gif')
    gif = gif_maker.get_id(request.giphy_id)

    print(f'{time.time() - start:.2f} Creating QR')
    qr = qr_builder\
        .with_text(request.text)\
        .with_version(request.version)\
        .with_transparency(request.transparency)\
        .build()
    
    size_qr = qr.get_size()
    size_mult = 2
    # size_gif = min(gif.height, gif.width)
    # size_mult = math.ceil(size_gif / size_qr)

    print(f'{time.time() - start:.2f} Combining QR with gif')
    combined = qr_gif_combiner.combine(gif=gif, qr=qr.image, size=size_qr*size_mult, color=ColorMode.COLOR)

    print(f'{time.time() - start:.2f} Upload to S3')
    key = s3_interactor.generate_unique_key()
    s3_interactor.upload_to_s3(combined.getvalue(), key)

    print(f'{time.time() - start:.2f} Generating presigned URL')
    url = s3_interactor.generate_presigned_url(key)

    print(f'{time.time() - start:.2f} Populating response body')
    # b64 = b64encode(combined.getvalue())
    # b64_str = b64.decode()
    response_body = {
        # 'image': b64_str,
        'url': url,
        'text': request.text
    }
    print(f'{time.time() - start:.2f} Complete')
    return response_body


def _fill_defaults(request_body) -> Dict:
    return request_body


def _populate_enums(request_body) -> Dict:
    return request_body
    