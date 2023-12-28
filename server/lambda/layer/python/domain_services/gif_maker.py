from dataclasses import dataclass
from io import BytesIO
from typing import Dict, List

import requests
from PIL import Image


@dataclass
class GiphyMetadata:
    type: str
    id: str
    height: int
    width: int
    url: str

    @staticmethod
    def from_json(json: Dict):
        image = json['images']['fixed_width']
        return GiphyMetadata(
            type=json['type'],
            id=json['id'],
            height=image['height'],
            width=image['width'],
            url=image['url'],
        )


class GifMaker:

    def __init__(self, api_key: str):
        self.key = api_key
    
    def get_id(self, id: str) -> Image:
        meta = self._get_metadata(id)
        return self._download_image(meta)

    def get_random(self) -> Image:
        meta = self._get_random_metadata()
        return self._download_image(meta)
    
    def get_search(self, text: str) -> Image:
        meta = self._get_search_metadata(text)
        return self._download_image(meta[0])
    
    def get_trending(self) -> Image:
        meta = self._get_trending_metadata()
        return self._download_image(meta[0])

    def _get_metadata(self, id: str) -> GiphyMetadata:
        params = {
            'api_key': self.key,
        }
        response = requests.get(f'http://api.giphy.com/v1/gifs/{id}', params=params)
        if not response.ok:
            raise Exception()
        return GiphyMetadata.from_json(response.json()['data'])

    def _get_random_metadata(self) -> GiphyMetadata:
        params = {
            'api_key': self.key,
            'limit': 1,
        }
        response = requests.get('http://api.giphy.com/v1/gifs/random', params=params)
        if not response.ok:
            raise Exception()
        return GiphyMetadata.from_json(response.json()['data'])

    def _get_search_metadata(self, text: str) -> List[GiphyMetadata]:
        params = {
            'api_key': self.key,
            'q': text,
            'limit': 1,
        }
        response = requests.get('http://api.giphy.com/v1/gifs/search', params=params)
        if not response.ok:
            raise Exception()
        return [GiphyMetadata.from_json(data) for data in response.json()['data']]

    def _get_trending_metadata(self) -> List[GiphyMetadata]:
        params = {
            'api_key': self.key,
            'limit': 1,
        }
        response = requests.get('http://api.giphy.com/v1/gifs/trending', params=params)
        if not response.ok:
            raise Exception()
        return [GiphyMetadata.from_json(data) for data in response.json()['data']]

    def _download_image(self, meta: GiphyMetadata) -> Image:
        r = requests.get(meta.url)
        return Image.open(BytesIO(r.content))
