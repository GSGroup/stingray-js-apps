var spaceBetweenBlocks = 1;
var glassWidth = 10;
var glassHeight = 20;
var blockSize = 30;
var gameWidth = blockSize * glassWidth;
var gameHeight = blockSize * glassHeight;

var pieces =[
	[0x44C0, 0x8E00, 0x6440, 0x0E20],
	[0x4460, 0x0E80, 0xC440, 0x2E00],
	[0xCC00, 0xCC00, 0xCC00, 0xCC00],
	[0x0F00, 0x2222, 0x00F0, 0x4444],
	[0x06C0, 0x8C40, 0x6C00, 0x4620],
	[0x0E40, 0x4C40, 0x4E00, 0x4640],
	[0x0C60, 0x4C80, 0xC600, 0x2640]
];

var colorGradientStart = ["#D8725A", "#DF81D4", "#E6CD70", "#C5D317", "#5F8BE3"];
var colorGradientEnd = ["#CE573D", "#D151BD", "#D9B42F", "#919C11", "#366DD9"];

this.randomColor = function() {
	return Math.floor(Math.random() * colorGradientStart.length);
}

this.randomBlockView = function() {
	return Math.floor(Math.random() * 7);
}

this.randomRotation = function() {
	return Math.floor(Math.random() * 4);
}

this.getGradientStart = function(colorIndex) {
	return colorGradientStart[colorIndex];
}

this.getGradientEnd = function(colorIndex) {
	return colorGradientEnd[colorIndex];
}

this.getBlockView = function(blockIndex, rotationIndex) {
	return pieces[blockIndex][rotationIndex];
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
