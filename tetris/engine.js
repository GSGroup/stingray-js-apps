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

this.getCurrentBlock = function() {
	return gameConsts.getBlockView(currentBlockViewIndex, currentRotationIndex);
}

this.getNextColorIndex = function() {
	return nextColorIndex;
}

this.getGradientStart = function(colorIndex) {
	return colorGradientStart[colorIndex];
}

this.getNextBlock = function() {
	return gameConsts.getBlockView(nextBlockViewIndex, nextRotationIndex);
}

var currentBlock = 0x0F00;
var nextBlock = 0x4460;

var currentBlockViewIndex = 0;
var nextBlockViewIndex = 1;

var currentRotationIndex = 0;
var nextRotationIndex = 1;

var nextBlockColor = 0;
var currentBlockColor = 1;

function hasCollisions(x,y) {
	var result = false;

	if ((x < 0) || (x >= game.width) || (y >= game.height) || game.getBlock(x,y)) {
		result = true;
	}

	return result;
}

function rotate() {
	currentRotationIndex = (currentRotationIndex == 3 ? 0 : currentRotationIndex + 1);
	currentBlock = pieces[currentBlockViewIndex][currentRotationIndex];
}

this.init = function() {
	currentBlockViewIndex = gameConsts.randomBlockView();
	nextBlockViewIndex = gameConsts.randomBlockView();

	currentRotationIndex = gameConsts.randomRotation();
	nextRotationIndex = gameConsts.randomRotation();

	nextColorIndex = gameConsts.randomColor();
	currentColorIndex = gameConsts.randomColor();

	dropTime = 16000;
}
