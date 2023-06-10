#!/usr/bin/env python3

from cell_type import CellType


def generate(target_dir, cell_width, cell_height, grid, grid_width, grid_height):
    with open(target_dir + "/PointArray.templ", 'r') as point_array_template:
        with open(target_dir + "/Point.templ", 'r') as point_template:
            with open(target_dir + "/generated_files/PacmanPointArray.qml", 'w') as result_file:
                point_template_string = point_template.read()
                for line in point_array_template:
                    if line.find("$array_of_points") == -1:
                        result_file.write(line)
                        continue

                    for y in range(grid_height):
                        for x in range(grid_width):
                            if grid[y][x] is None:
                                grid[y][x] = CellType.POINT
                                result_file.write(point_template_string
                                                  .replace("$x", str(x))
                                                  .replace("$y", str(y))
                                                  .replace("$pos_x", str(x * cell_width))
                                                  .replace("$pos_y", str(y * cell_height)))
    return grid
