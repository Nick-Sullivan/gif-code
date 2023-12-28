from enum import Enum


class ColorMode(Enum):
    GREYSCALE = 1
    COLOR = 2

class CoordinateSystem(Enum):
    INDEX = 1      # (i) from 0 to size*size
    PIXEL = 2      # (x,y) from 0 to size
    BOX_PIXEL = 3  # (x,y) from 0 to box_size
    BOX_INDEX = 4  # (x,y) from 0 to num_boxes
