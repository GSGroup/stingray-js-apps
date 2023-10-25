const objectMap = new Map();
let grid = [];

function getObjectId(x, y) {
    return x + '/' + y;
}

this.getCellType = function(x, y) {
    return grid[y][x];
}

this.setCellType = function(x, y, type) {
    grid[y][x] = type;
}

this.getGrid = function() {
    return grid;
}

this.setGrid = function(grid_) {
    grid = grid_;
}

this.getObject = function(x, y) {
    return objectMap.get(getObjectId(x, y));
}

this.setObject = function(x, y, object) {
    objectMap.set(getObjectId(x, y), object);
}
