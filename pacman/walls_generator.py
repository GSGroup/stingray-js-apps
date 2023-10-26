#!/usr/bin/env python3

from cell_type import CellType


class BoxBottomRightCorner:
    pass


class EndOfHLine:
    pass


class EndOfVLine:
    pass


def create_h_line(grid, start_x, end_x, y, tail_cell_type = EndOfHLine()):
    for x in range(start_x, end_x):
        if grid[y][x] == CellType.VER_WALL:
            grid[y][x] = CellType.BOTH_WALLS
        else:
            grid[y][x] = CellType.HOR_WALL

    if tail_cell_type is not None:
        grid[y][end_x] = tail_cell_type


def create_mirrored_h_lines(grid, start_x, end_x, y, grid_width, tail_cell_type = EndOfHLine(), mirrored_tail_cell_type = EndOfHLine()):
    create_h_line(grid, start_x, end_x, y, tail_cell_type)
    create_h_line(grid, grid_width - end_x - 1, grid_width - start_x - 1, y, mirrored_tail_cell_type)


def create_v_line(grid, start_y, end_y, x, tail_cell_type = EndOfVLine()):
    for y in range(start_y, end_y):
        if grid[y][x] == CellType.HOR_WALL:
            grid[y][x] = CellType.BOTH_WALLS
        else:
            grid[y][x] = CellType.VER_WALL

    if tail_cell_type is not None:
        grid[end_y][x] = tail_cell_type


def create_mirrored_v_lines(grid, start_y, end_y, x, grid_width, tail_cell_type = EndOfVLine(), mirrored_tail_cell_type = EndOfVLine()):
    create_v_line(grid, start_y, end_y, x, tail_cell_type)
    create_v_line(grid, start_y, end_y, grid_width - x - 1, mirrored_tail_cell_type)


def delete_points(grid, start_x, end_x, start_y, end_y):
    for x in range(start_x, end_x):
        for y in range(start_y, end_y):
            grid[y][x] = CellType.EMPTY


def create_box(grid, start_x, end_x, start_y, end_y, delete_points_inside = True):
    create_h_line(grid, start_x, end_x, start_y, None)
    create_h_line(grid, start_x, end_x, end_y, None)

    create_v_line(grid, start_y, end_y, start_x, None)
    create_v_line(grid, start_y, end_y, end_x, None)

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
                elif isinstance(grid[y][x], EndOfHLine):
                    grid[y][x] = CellType.HOR_WALL
                elif isinstance(grid[y][x], EndOfVLine):
                    grid[y][x] = CellType.VER_WALL

    return grid
