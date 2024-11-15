
from io import BytesIO

import pytest
from PIL import Image, ImageChops

from .endpoints import create, get_image


@pytest.fixture(scope='module')
def response():
    request = {
        'text': 'This is an API test',
        'giphy_id': 'WHv84VIQYOHBibUy6K',
        'transparency': 200,
        'version': 6,
        'is_boomerang': False,
    }
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


@pytest.fixture(scope='module')
def expected_image() -> Image:
    yield Image.open('tests/api/expected.gif')


def test_it_returns_status_200(response):
    assert response.status_code == 200


def test_it_returns_text(response_body):
    assert 'text' in response_body
    assert response_body['text'] == 'This is an API test'


def test_it_returns_transparency(response_body):
    assert 'transparency' in response_body
    assert response_body['transparency'] == 200


def test_it_returns_url(response_body):
    assert 'url' in response_body


def test_it_returns_id(response_body):
    assert 'id' in response_body


def test_image_is_gif(image):
    assert image.format == 'GIF'


def test_image_size_is_as_expected(image, expected_image):
    assert image.width == expected_image.width
    assert image.height == expected_image.height


def test_image_duration_is_as_expected(image, expected_image):
    assert image.info['duration'] == expected_image.info['duration']


def test_image_mode_is_as_expected(image, expected_image):
    assert image.mode == expected_image.mode


def test_image_looks_as_expected(image, expected_image):
    # Uncomment this to save and view
    # from domain_services.qr_gif_combiner import QrGifCombiner
    # QrGifCombiner().save_gif(image, 'tests/api/actual.gif')
    diff = ImageChops.difference(image, expected_image)
    diff_pixels = list(diff.getdata())
    pixel_threshold = 30
    num_identical = sum(pixel <= pixel_threshold for pixel in diff_pixels)
    num_total = len(diff_pixels)
    ratio = num_identical / num_total
    assert ratio > 0.8
