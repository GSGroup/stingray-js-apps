var objectMap = new Map();
var grid = [];

this.getCellType = function(width, height) {
    return grid[height][width];
}

this.setCellType = function(width, height, val) {
    grid[height][width] = val;
}

this.getGrid = function() {
    return grid;
}

this.setGrid = function(newGrid) {
    grid = newGrid;
}

this.getObject = function(id) {
    return objectMap.get(id);
}

this.setObject = function(id, object) {
    objectMap.set(id, object);
}
