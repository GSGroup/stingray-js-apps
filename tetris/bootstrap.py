#!/usr/bin/env python3

import argparse
import os
import sys
import shutil

def main():
    parser = argparse.ArgumentParser(description='Tetris bootstrap')
    parser.add_argument("target_dir")
    args = parser.parse_args()

    file_cover_template = open(args.target_dir + "/cover_template.templ", "r")
    file_rect_template = open(args.target_dir + "/rect_template.templ", "r")
    file_glass_size = open(args.target_dir + "/glassSize.templ", "r")
    file_const_template = open(args.target_dir + "/tetrisConsts.templ", "r")
	
    try:
        if os.path.exists(args.target_dir + "/generatedfiles"):
            shutil.rmtree(args.target_dir + "/generatedfiles")
        os.mkdir(args.target_dir + "/generatedfiles")

    except OSError as error:
        print("Tetris bootstrap error: " + str(error))
        sys.exit(1)

    file_const_result = open(args.target_dir + "/generatedfiles/tetrisConsts.js", "w")
    file_result = open(args.target_dir + "/generatedfiles/RectArray.qml", "w")

    for line in file_glass_size:
        if line.find("glassWidth") != -1:
            glass_width = int("".join(filter(str.isdigit, line)))
        elif line.find("glassHeight") != -1:
            glass_height = int("".join(filter(str.isdigit, line)))

    rect_template = ""
    for line in file_rect_template:
        rect_template += line

    for line in file_cover_template:
        if line.find("$array_of_rect") == -1:
            file_result.write(line)
        else:
            for y in range(glass_height):
                for x in range(glass_width):
                    file_result.write((rect_template.replace("$x", str(x))).replace("$y", str(y)))

    const_template = ""
    for line in file_const_template:
        const_template += line

    file_const_result.write((const_template.replace("$glassWidth", str(glass_width))).replace("$glassHeight", str(glass_height)))

    file_const_template.close()
    file_const_result.close()
    file_result.close()
    file_cover_template.close()
    file_rect_template.close()

if __name__ == "__main__":
    main()