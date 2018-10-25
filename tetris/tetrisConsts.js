var spaceBetweenBlocks = 1;
var glassWidth = 10;
var glassHeight = 20;
var blockSize = 30;
var gameWidth = blockSize * glassWidth;
var gameHeight = blockSize * glassHeight;
var blockNumber = glassHeight * glassWidth;

var colorCollection = [ "#CE573D", "#D151BD", "#D9B42F", "#919C11", "#366DD9" ];

this.randomColor = function() {
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

this.getBlockSize = function() {
	return blockSize;
}

this.getSpaceBetweenBlocks = function() {
	return spaceBetweenBlocks;
}
