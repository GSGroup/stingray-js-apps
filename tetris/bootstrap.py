#!/usr/bin/env python3

# © "Сifra" LLC, 2011-2025
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
# provided that the above copyright notice and this permission notice appear in all copies.
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import argparse
import os

def main():
    parser = argparse.ArgumentParser(description='Tetris bootstrap')
    parser.add_argument("target_dir")
    args = parser.parse_args()

    file_cover_template = open(args.target_dir + "/cover_template.templ", "r")
    file_rect_template = open(args.target_dir + "/rect_template.templ", "r")
    file_glass_size = open(args.target_dir + "/glassSize.templ", "r")
    file_const_template = open(args.target_dir + "/tetrisConsts.templ", "r")

    generated_files_path = os.path.join(args.target_dir, "generated_files")

    if not os.path.exists(generated_files_path):
        os.mkdir(generated_files_path)

    file_const_result = open(os.path.join(generated_files_path, "tetrisConsts.js"), "w")
    file_result = open(os.path.join(generated_files_path, "RectArray.qml"), "w")

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