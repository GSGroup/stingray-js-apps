const objectMap = new Map();
let grid = [];

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

this.getObject = function(id) {
    return objectMap.get(id);
}

this.setObject = function(id, object) {
    objectMap.set(id, object);
}
