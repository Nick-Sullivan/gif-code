
from io import BytesIO

import pytest
from PIL import Image, ImageChops

from .endpoints import create, get_image


@pytest.fixture(scope='module')
def response():
    request = {'text': 'This is an API test', 'giphy_id': '', 'transparency': 200, 'version': 6}
    response = create(request)
    yield response


@pytest.fixture(scope='module')
def response_body(response):
    body = response.json()
    yield body


@pytest.fixture(scope='module')
def image(response_body) -> Image:
    try:
        response = get_image(response_body['url'])
        byte_stream = BytesIO(response.content)
        yield Image.open(byte_stream)
    finally:
        return


def test_it_returns_status_200(response):
    assert response.status_code == 200


def test_it_returns_text(response_body):
    assert 'text' in response_body
    assert response_body['text'] == 'This is an API test'


def test_it_returns_url(response_body):
    assert 'url' in response_body


def test_image_is_gif(image):
    assert image.format == 'GIF'


def test_image_size_is_as_expected(image):
    assert image.width == 344
    assert image.height == 344
