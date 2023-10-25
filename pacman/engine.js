const pointsMap = new Map();
let grid = [];

function getPointId(x, y) {
    return x + '/' + y;
}

this.getCellType = function(x, y) {
    return grid[y][x];
}

this.isWall = function(x, y) {
    const type = this.getCellType(x, y);
    return type != gameConsts.CellType.EMPTY && type != gameConsts.CellType.POINT;
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
