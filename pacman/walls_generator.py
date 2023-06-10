#!/usr/bin/env python3

from cell_type import CellType


class BoxBottomRightCorner:
    pass


def create_line_h(grid, start_x, end_x, y):
    for x in range(start_x, end_x):
        if grid[y][x] == CellType.VER_WALL:
            grid[y][x] = CellType.BOTH_WALLS
        else:
            grid[y][x] = CellType.HOR_WALL


def create_line_v(grid, x, start_y, end_y):
    for y in range(start_y, end_y):
        if grid[y][x] == CellType.HOR_WALL:
            grid[y][x] = CellType.BOTH_WALLS
        else:
            grid[y][x] = CellType.VER_WALL


def delete_points(grid, start_x, end_x, start_y, end_y):
    for x in range(start_x, end_x):
        for y in range(start_y, end_y):
            grid[y][x] = CellType.EMPTY


def create_box(grid, start_x, end_x, start_y, end_y, delete_points_inside = True):
    create_line_h(grid, start_x, end_x, start_y)
    create_line_h(grid, start_x, end_x, end_y)

    create_line_v(grid, start_x, start_y, end_y)
    create_line_v(grid, end_x, start_y, end_y)

    grid[end_y][end_x] = BoxBottomRightCorner()

    if delete_points_inside:
        delete_points(grid, start_x + 1, end_x, start_y + 1, end_y)


def write_walls(grid, result_file, wall_type, wall_string_template, cell_width, cell_height, start_index):
    index = start_index
    for y, row in enumerate(grid):
        for x, elem in enumerate(row):
            if elem == wall_type or elem == CellType.BOTH_WALLS:
                result_file.write(wall_string_template
                                  .replace("$index", str(index))
                                  .replace("$pos_x", str(x * cell_width))
                                  .replace("$pos_y", str(y * cell_height)))
                index = index + 1
    return index


def generate(target_dir, cell_width, cell_height, grid_width, grid_height):
    grid = []

    for y in range(grid_height):
        grid.append([])
        for _ in range(grid_width):
            grid[y].append(None)

    create_box(grid, 0, grid_width - 1, 0, grid_height - 1, False)

    create_box(grid, 2, 5, 2, 4)
    create_box(grid, 7, 9, 2, 4)
    create_box(grid, 11, 13, 2, 4)
    create_box(grid, 15, 18, 2, 4)

    create_box(grid, 2, 5, 6, 8)
    create_box(grid, 7, 9, 6, 8)
    create_box(grid, 11, 13, 6, 8)
    create_box(grid, 15, 18, 6, 8)

    create_box(grid, 2, 5, 12, 14)
    create_box(grid, 7, 9, 12, 14)
    create_box(grid, 11, 13, 12, 14)
    create_box(grid, 15, 18, 12, 14)

    create_box(grid, 2, 5, 16, 18)
    create_box(grid, 7, 9, 16, 18)
    create_box(grid, 11, 13, 16, 18)
    create_box(grid, 15, 18, 16, 18)

    with open(target_dir + "/generated_files/PacmanWallArray.qml", "w") as result_file:
        with open(target_dir + "/WallArray.templ", "r") as wall_array_template:
            with open(target_dir + "/VerticalWall.templ", "r") as vertical_wall_template:
                vertical_wall_template_string = vertical_wall_template.read()
                with open(target_dir + "/HorizontalWall.templ", "r") as horizontal_wall_template:
                    horizontal_wall_template_string = horizontal_wall_template.read()
                    for line in wall_array_template:
                        if line.find("$array_of_walls") == -1:
                            result_file.write(line)
                            continue

                        last_index = write_walls(grid, result_file, CellType.VER_WALL,
                                              vertical_wall_template_string, cell_width, cell_height, 0)
                        write_walls(grid, result_file, CellType.HOR_WALL, horizontal_wall_template_string,
                                    cell_width, cell_height, last_index)

        for x in range(grid_width):
            for y in range(grid_height):
                if isinstance(grid[y][x], BoxBottomRightCorner):
                    grid[y][x] = CellType.BOTH_WALLS

    return grid
