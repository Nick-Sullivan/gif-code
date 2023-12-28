
from dataclasses import dataclass

from PIL import Image


@dataclass
class Qr:
    image: Image

    def save_image(self, file: str):
        self.image.save(file)

    def get_size(self) -> int:
        return self.image.width
        