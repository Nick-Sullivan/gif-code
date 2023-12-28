import os

from .gif_maker import GifMaker
from .qr_builder import QrBuilder
from .qr_gif_combiner import QrGifCombiner

gif_maker = GifMaker(os.environ['GIPHY_API_KEY'])
qr_builder = QrBuilder()
qr_gif_combiner = QrGifCombiner()
