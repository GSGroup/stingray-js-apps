var gameConsts = require("tetris", "tetrisConsts.js");

var currentBlock;
var nextBlock;
var currentBlockViewIndex;
var nextBlockViewIndex;
var currentRotationIndex;
var nextRotationIndex;
var nextColorIndex;
var currentColorIndex;
var dropTime;

var pieces =[
	[0x44C0, 0x8E00, 0x6440, 0x0E20],
	[0x4460, 0x0E80, 0xC440, 0x2E00],
	[0xCC00, 0xCC00, 0xCC00, 0xCC00],
	[0x0F00, 0x2222, 0x00F0, 0x4444],
	[0x06C0, 0x8C40, 0x6C00, 0x4620],
	[0x0E40, 0x4C40, 0x4E00, 0x4640],
	[0x0C60, 0x4C80, 0xC600, 0x2640]
];

function randomBlockView() {
	return Math.floor(Math.random() * 7);
}

function randomRotation() {
	return Math.floor(Math.random() * 4);
}

this.getCurrentBlock = function() {
	return pieces[currentBlockViewIndex][currentRotationIndex];
}

this.getNextBlock = function() {
	return pieces[nextBlockViewIndex][nextRotationIndex];
}

this.getNextColorIndex = function() {
	return nextColorIndex;
}

this.getGradientStart = function(colorIndex) {
	return colorGradientStart[colorIndex];
}

this.index = function(x, y) {
	return (Math.floor(y / gameConsts.getBlockSize()) * gameConsts.getGlassWidth() + Math.floor(x / gameConsts.getBlockSize()));
}

this.rotate = function() {
	currentRotationIndex = (currentRotationIndex === 3 ? 0 : currentRotationIndex + 1);
}

var nextBlockColor = 0;
var currentBlockColor = 1;

function hasCollisions(x,y) {
	var result = false;
	if ((x < 0) || (x >= gameConsts.getGameWidth()) || (y >= gameConsts.getGameHeight())) {
		result = true;
	}
	return result;
}

this.setMovingBlockProperties = function() {
	currentBlockViewIndex = nextBlockViewIndex;
	currentRotationIndex = nextRotationIndex;
	currentColorIndex = nextColorIndex;

	nextBlockViewIndex = randomBlockView();
	nextRotationIndex = randomRotation();
	nextColorIndex = gameConsts.randomColor();
}

this.init = function() {
	currentBlockViewIndex = randomBlockView();
	currentRotationIndex = randomRotation();
	currentColorIndex = gameConsts.randomColor();

	nextRotationIndex = randomRotation();
	nextBlockViewIndex = randomBlockView();
	nextColorIndex = gameConsts.randomColor();

	dropTime = 16000;
}
