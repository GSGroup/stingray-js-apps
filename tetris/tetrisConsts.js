var spaceBetweenBlocks = 1;
var glassWidth = 10;
var glassHeight = 17;
var blockSize = 35;
var gameWidth = blockSize * glassWidth;
var gameHeight = blockSize * glassHeight;
var blockNumber = glassHeight * glassWidth;

var colorCollection = [ "#FF6331", "#D151BD", "#FFD200", "#93AD00", "#0090FF" ];

this.randomColorIndex = function() {
	return Math.floor(Math.random() * colorCollection.length);
}

this.getBlockNumber = function(colorIndex) {
	return blockNumber;
}

this.getColor = function(colorIndex) {
	return colorCollection[colorIndex];
}

this.getGameWidth = function() {
	return gameWidth;
}

this.getGameHeight = function() {
	return gameHeight;
}

this.getGlassWidth = function() {
	return glassWidth;
}

this.getGlassHeight = function() {
	return glassHeight;
}

this.getBlockSize = function() {
	return blockSize;
}

this.getSpaceBetweenBlocks = function() {
	return spaceBetweenBlocks;
}
