from io import BytesIO

from domain_models.image import ColorMode
from PIL import Image, ImageSequence


class QrGifCombiner:
    def combine(
        self, gif: Image, qr: Image, size: int, color: ColorMode, boomerang: bool
    ) -> BytesIO:
        self.size = size
        self.image = gif
        self.frames = ImageSequence.Iterator(self.image)
        self._crop_to_square()
        self._resize()
        self._convert(color)
        if boomerang:
            self._boomerang()
        self._add_qr(qr)
        return self._combine_frames()

    def _combine_frames(self) -> BytesIO:
        gif = BytesIO()
        self.frames[0].save(
            gif,
            save_all=True,
            format="GIF",
            append_images=self.frames[1:],
            duration=self.image.info["duration"],
            loop=0,
        )
        gif.seek(0, 2)
        return gif

    def _add_qr(self, qr: Image):
        # qr = qr.resize((self.size, self.size), Image.NEAREST)
        qr = qr.resize((self.size, self.size), Image.BICUBIC)
        for frame in self.frames:
            frame.paste(im=qr, box=(0, 0), mask=qr)

    def _crop_to_square(self):
        dx, dy = self.frames[0].size
        min_len = min(self.frames[0].size)
        new_frames = []
        for frame in self.frames:
            img = frame.crop(
                (
                    dx / 2 - min_len / 2,
                    dy / 2 - min_len / 2,
                    dx / 2 + min_len / 2,
                    dy / 2 + min_len / 2,
                )
            )
            new_frames.append(img)
        self.frames = new_frames

    def _resize(self):
        new_frames = []
        for frame in self.frames:
            img = frame.resize((self.size, self.size), Image.BICUBIC)
            new_frames.append(img)
        self.frames = new_frames

    def _convert(self, color):
        new_frames = []
        for frame in self.frames:
            mode = {
                ColorMode.GREYSCALE: "L",
                ColorMode.COLOR: "RGBA",
            }[color]
            img = frame.convert(mode)
            new_frames.append(img)
        self.frames = new_frames

    def _boomerang(self):
        for frame in reversed(self.frames):
            self.frames.append(frame)

    @staticmethod
    def save_gif(gif: Image, path: str):
        frames = list(ImageSequence.Iterator(gif))
        frames[0].save(
            path,
            save_all=True,
            format="GIF",
            append_images=frames[1:],
            duration=gif.info["duration"],
            loop=0,
        )
