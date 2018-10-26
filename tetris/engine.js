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

this.getTimerInterval = function() {
	return dropTime / (gameConsts.getGlassHeight() - 4) / currentLevel;
}

this.initCanvas = function(model) {
	for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.append({ value: 0, colorIndex: 0, backColor: colorTheme.backgroundColor });
		canvasState.push({ value: model.get(idx).value, colorIndex: model.get(idx).value });
	}
}

this.initMovingTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		var value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.append({ value: value, colorIndex: currentColorIndex, backColor: colorTheme.backgroundColor });
		movingBlockState.push({ value: value, colorIndex: currentColorIndex });
	}
}

this.initNextTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		var value = pieces[nextBlockViewIndex][nextRotationIndex] & bit;
		model.append({ value: value, colorIndex: 0, backColor: colorTheme.globalBackgroundColor });
	}
}

function init() {
	currentBlockViewIndex = randomBlockViewIndex();
	currentRotationIndex = randomRotationIndex();
	currentColorIndex = gameConsts.randomColorIndex();

	nextRotationIndex = randomRotationIndex();
	nextBlockViewIndex = randomBlockViewIndex();
	nextColorIndex = gameConsts.randomColorIndex();

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
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		var value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.set(indexBlock, { value: value, colorIndex: currentColorIndex });
		movingBlockState[indexBlock].value = value;
		movingBlockState[indexBlock].colorIndex = currentColorIndex;
	}
}

function updateBlockState() {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock) {
		movingBlockState[indexBlock].value =  pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		movingBlockState[indexBlock].colorIndex = currentColorIndex;

		++indexBlock;
	}
}

this.updateBlockModel = function(model) {
	for (var idx = 0; idx < 16; ++idx) {
		model.set(idx, { value: movingBlockState[idx].value, colorIndex: movingBlockState[idx].colorIndex });
	}
}

this.updateMovingTetraminos = function(model) {
	updateBlockState()
	this.updateBlockModel(model);
}

this.updateNextTetraminos = function(model) {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		var value = pieces[nextBlockViewIndex][nextRotationIndex] & bit;
		model.set(indexBlock, { value: value, colorIndex: nextColorIndex });
	}
}

this.restartGame = function(gameViewModel, blockViewModel, nextBlockViewModel) {
	this.clearCanvas(gameViewModel);
	init();

	this.updateMovingTetraminos(blockViewModel);
	this.updateNextTetraminos(nextBlockViewModel);
}

this.clearCanvas = function(model) {
	for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.set(idx, { value: 0, colorIndex: 0 });
		canvasState[idx].value = 0;
		canvasState[idx].colorIndex = 0;
	}
}

this.makeBlockPartOfCanvas = function(model) {
}

this.tryRotate = function(x, y, model) {
	var rotationIndex = currentRotationIndex;
	currentRotationIndex = (currentRotationIndex === 3 ? 0 : currentRotationIndex + 1);
	updateBlockState();
	if (!this.checkColllisions(x,y)) {
		this.updateBlockModel(model);
		this.updateProperties(x, y, model)
	}
	else {
		currentRotationIndex = rotationIndex;
		updateBlockState();
	}
}

this.hasColllisions = function(x, y) {
	if(hasBorderCollisions(x, y) || hasCanvasCollisions(x, y))
	{
		return true;
	}
	return false;
}

this.updateProperties = function(x, y, model) {
	var blockX;
	var blockY;

	for (var k = 0; k < 16; ++k) {
		blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if ( (blockX < 0 || blockX >= gameConsts.getGameWidth() || blockY >= gameConsts.getGameHeight())) {
			movingBlockState[k].value = -1;
			model.set(k, { value: -1 });
		}
		else if (movingBlockState[k].value === -1){
			movingBlockState[k].value = 0;
			model.set(k, { value: 0 });
		}
	}
}

function hasBorderCollisions(x, y) {
	var blockX;
	var blockY;

	for (var k = 0; k < 16; ++k) {
		blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if ( (blockX < 0 || blockX >= gameConsts.getGameWidth() || blockY >= gameConsts.getGameHeight()) && movingBlockState[k].value > 0) {
			return true;
		}
	}
	return false;
}

function hasCanvasCollisions(x, y) {
	var result = false;
	return result;
}

function randomBlockViewIndex() {
	return Math.floor(Math.random() * 7);
}

function randomRotationIndex() {
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

	nextBlockViewIndex = randomBlockViewIndex();
	nextRotationIndex = randomRotationIndex();
	nextColorIndex = gameConsts.randomColorIndex();
}
