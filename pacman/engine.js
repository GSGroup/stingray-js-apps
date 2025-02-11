// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const pointsMap = new Map();
let grid = [];

function getPointId(x, y) {
    return x + '/' + y;
}

this.isWall = function(x, y) {
    const cell = grid[y][x];
    return cell != gameConsts.CellType.EMPTY && cell != gameConsts.CellType.POINT;
}

this.getGrid = function() {
    return grid;
}

this.setGrid = function(grid_) {
    grid = grid_;
}

this.getPoint = function(x, y) {
    return pointsMap.get(getPointId(x, y));
}

this.setPoint = function(x, y, point) {
    pointsMap.set(getPointId(x, y), point);
}

this.getPointsCount = function() {
    return pointsMap.size;
}
