#!/usr/bin/env python3

import argparse
import os
import sys
import shutil
import points_generator
import walls_generator
from cell_type import CellType

grid_width = 21
grid_height = 21

cell_width = 30
cell_height = 30

initial_player_pos = [10, 15]
initial_enemies_pos = [
    [9, 7],
    [9, 7],
    [10, 7],
    [11, 7] ]

def main():
    parser = argparse.ArgumentParser(description='Pacman bootstrap')
    parser.add_argument("target_dir")
    args = parser.parse_args()

    try:
        if os.path.exists(args.target_dir + "/generated_files"):
            shutil.rmtree(args.target_dir + "/generated_files")
        os.mkdir(args.target_dir + "/generated_files")
    except OSError as error:
        print("Pacman bootstrap error: " + str(error))
        sys.exit(1)

    grid = walls_generator.generate(args.target_dir, cell_width, cell_height, grid_width, grid_height)
    grid = points_generator.generate(args.target_dir, cell_width, cell_height, grid, grid_width, grid_height)

    with open(args.target_dir + "/generated_files/pacmanConsts.js", "w") as consts_result_file:
        with open(args.target_dir + "/pacmanConsts.templ", "r") as consts_template:
            consts_template_string = consts_template.read()

        cell_types = ""
        for cell_type in CellType:
            cell_types += "  " + str(cell_type.name) + ": " + str(cell_type.value) + ",\n"

        grid_string = "[\n"
        for line in grid:
            grid_string += "["
            grid_string += ", ".join(str(el) for el in line)
            grid_string += "],\n"
        grid_string += "];\n\n"

        consts_template_string = consts_template_string.replace("$cell_types", cell_types) \
                .replace("$cell_width", str(cell_width)) \
                .replace("$cell_height", str(cell_height)) \
                .replace("$grid_width", str(grid_width)) \
                .replace("$grid_height", str(grid_height)) \
                .replace("$grid", str(grid_string))    \
                .replace("$initial_player_pos", str(initial_player_pos))    \
                .replace("$initial_enemies_pos", str(initial_enemies_pos))

        consts_result_file.write(consts_template_string)

if __name__ == "__main__":
    main()
