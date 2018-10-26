var gameConsts = require("tetris", "tetrisConsts.js");

var currentBlockViewIndex;
var nextBlockViewIndex;
var currentRotationIndex;
var nextRotationIndex;
var nextColorIndex;
var currentColorIndex;
var dropTime;
var currentLevel;

var pieces =[
	[0x44C0, 0x8E00, 0x6440, 0x0E20],
	[0x4460, 0x0E80, 0xC440, 0x2E00],
	[0xCC00, 0xCC00, 0xCC00, 0xCC00],
	[0x0F00, 0x2222, 0x00F0, 0x4444],
	[0x06C0, 0x8C40, 0x6C00, 0x4620],
	[0x0E40, 0x4C40, 0x4E00, 0x4640],
	[0x0C60, 0x4C80, 0xC600, 0x2640]
];

var canvasState = [];
var movingBlockState = [];

this.initCanvas = function(model) {
	for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.append({ value: 0, colorIndex: 0, backColor: colorTheme.backgroundColor });
		canvasState.push({ value: model.get(idx).value, colorIndex: model.get(idx).value});
	}
}

this.initMovingTetraminos = function(model) {
	var bit;
	var value;
	for (bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.append({ value: value, colorIndex: currentColorIndex, backColor: colorTheme.backgroundColor });
		movingBlockState.push({ value: value, colorIndex: currentColorIndex });
	}
}

this.initNextTetraminos = function(model) {
	var bit;
	var value;
	for (bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		value = pieces[nextBlockViewIndex][nextRotationIndex] & bit;
		model.append({ value: value, colorIndex: 0, backColor: colorTheme.globalBackgroundColor });
	}
}

function init() {
	currentBlockViewIndex = randomBlockView();
	currentRotationIndex = randomRotation();
	currentColorIndex = gameConsts.randomColor();

	nextRotationIndex = randomRotation();
	nextBlockViewIndex = randomBlockView();
	nextColorIndex = gameConsts.randomColor();

	dropTime = 16000;
	currentLevel = 1;
}

this.getDropTime = function() {
	return dropTime;
}

this.initGame = function(gameViewModel, blockViewModel, nextBlockViewModel) {
	init();

	this.initCanvas(gameViewModel);
	this.initMovingTetraminos(blockViewModel);
	this.initNextTetraminos(nextBlockViewModel);
}

this.nextStep = function(blockViewModel, nextBlockViewModel) {
	setProperties();

	this.updateMovingTetraminos(blockViewModel);
	this.updateNextTetraminos(nextBlockViewModel);
}

this.updateMovingTetraminos = function(model) {
	var bit;
	var indexBlock = 0;
	var value;
	for (bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.set(indexBlock, { value: value, colorIndex: currentColorIndex });
		movingBlockState[indexBlock].value = value;
		movingBlockState[indexBlock].colorIndex = currentColorIndex;
		++indexBlock;
	}

	for (var idx = 0; idx < 16; ++idx)
	{

	}
}

this.updateNextTetraminos = function(model) {
	var bit;
	var indexBlock = 0;
	var value;
	for (bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		value = pieces[nextBlockViewIndex][nextRotationIndex] & bit;
		model.set(indexBlock, { value: value, colorIndex: nextColorIndex });
		++indexBlock;
	}
}

this.restartGame = function(gameViewModel, blockViewModel, nextBlockViewModel) {
	this.clearCanvas(gameViewModel);
	init();

	this.updateMovingTetraminos(blockViewModel);
	this.updateNextTetraminos(nextBlockViewModel);
}

this.clearCanvas = function(model) {
	for (var idx; idx < gameConsts.getBlockNumber(); ++i)
	{
		model.set(idx,{ value: 0, colorIndex: 0 });
		canvasState[idx].value = 0;
		canvasState[idx].colorIndex = 0;
	}
}

this.makeBlockPartOfCanvas = function() {
}

this.tryRotate = function() {
	return true;
}

this.hasColllisions = function(x, y) {
	if(hasBorderCollisions(x, y) || hasCanvasCollisions(x, y))
	{
		return true;
	}
	return false;
}

function hasBorderCollisions(x, y) {
	var blockX;
	var blockY;

	for (var k = 0; k < 16; ++k)
	{
		blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if (blockX < 0 || blockX >= gameConsts.getGameWidth() || blockY >= gameConsts.getGameHeight())
		{
			return true;
		}
	}
	return false;
}

function hasCanvasCollisions(x, y) {
	var result = false;
	return result;
}

function randomBlockView() {
	return Math.floor(Math.random() * 7);
}

function randomRotation() {
	return Math.floor(Math.random() * 4);
}

function index(x, y) {
	return (Math.floor(y / gameConsts.getBlockSize()) * gameConsts.getGlassWidth() + Math.floor(x / gameConsts.getBlockSize()));
}

this.rotate = function() {
	currentRotationIndex = (currentRotationIndex === 3 ? 0 : currentRotationIndex + 1);
}

function setProperties() {
	currentBlockViewIndex = nextBlockViewIndex;
	currentRotationIndex = nextRotationIndex;
	currentColorIndex = nextColorIndex;

	nextBlockViewIndex = randomBlockView();
	nextRotationIndex = randomRotation();
	nextColorIndex = gameConsts.randomColor();
}
