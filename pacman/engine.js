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
