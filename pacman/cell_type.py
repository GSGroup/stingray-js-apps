from enum import Enum


class CellType(Enum):
    EMPTY = 0
    POINT = 1
    HOR_WALL = 2
    VER_WALL = 3
    BOTH_WALLS = 4
