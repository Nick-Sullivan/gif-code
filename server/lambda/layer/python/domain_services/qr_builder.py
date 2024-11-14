
from typing import Tuple

import qrcode
from domain_models.image import CoordinateSystem
from domain_models.qr import Qr
from PIL import Image


class QrBuilder:

    def __init__(self):
        self._set_defaults()

    def _set_defaults(self):
        self.box_size = 4
        self.border = 1
        self.text = "This is some example text"
        self.version = 3
        self.qr = None
        self.width = None
        self.transparency = 255

    def with_text(self, text: str):
        self.text = text
        return self
    
    def with_version(self, version: int):
        self.version = version
        return self

    def with_transparency(self, transparency: int):
        self.transparency = transparency
        return self

    def build(self) -> Qr:
        self.qr = self._make_qr()
        self.num_boxes = self.border*2 + self.qr.modules_count
        self.width = self.num_boxes * self.box_size
        image = self._make_image()
        self._set_defaults()
        return Qr(image=image)

    def _make_qr(self) -> qrcode.QRCode:
        qr = qrcode.QRCode(version=self.version, box_size=self.box_size, border=self.border)
        qr.add_data(self.text)
        qr.make(fit=True)
        return qr

    def _make_image(self) -> Image:
        trans_image = self.qr.make_image().convert('RGBA')
        data = []
        for i, pixel in enumerate(trans_image.getdata()):
            if self._is_in_marker(i):
                data.append((pixel[0], pixel[1], pixel[2], self.transparency))
            elif self._is_in_centre(i): 
                data.append((pixel[0], pixel[1], pixel[2], self.transparency))
            else:
                data.append((0, 0, 0, 0))
        trans_image.putdata(data)
        return trans_image

    def _convert_coordinates(self, index: int, to: CoordinateSystem) -> Tuple[int, int]:
        x = index % self.width
        y = int(index/self.width)
        if to == CoordinateSystem.PIXEL:
            return x, y
        if to == CoordinateSystem.BOX_PIXEL:
            return x % self.box_size, y % self.box_size
        if to == CoordinateSystem.BOX_INDEX:
            return int(x / self.box_size), int(y / self.box_size)
    
    def _is_in_marker(self, index):
        x, y = self._convert_coordinates(index, CoordinateSystem.BOX_INDEX)
        # border
        if x == 0:
            return True
        if y == 0:
            return True
        if x == self.num_boxes-1:
            return True
        if y == self.num_boxes-1:
            return True
        # top left
        if 0 <= x < 9 and 0 <= y < 9:
            return True
        # top right
        if self.num_boxes-10 < x <= self.num_boxes and 0 <= y < 9:
            return True
        # bottom left
        if 0 <= x < 9 and self.num_boxes-10 < y <= self.num_boxes:
            return True
        return False

    def _is_in_centre(self, index):
        assert self.box_size % 4 == 0, "only supports box sizes divisible by 4"
        x, y = self._convert_coordinates(index, CoordinateSystem.BOX_PIXEL)
        is_x = self.box_size / 4 <= x < 3 * self.box_size / 4
        is_y = self.box_size / 4 <= y < 3 * self.box_size / 4
        return is_x and is_y
    