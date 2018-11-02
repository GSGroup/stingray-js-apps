var gameConsts = require("tetris", "tetrisConsts.js");

var currentBlockViewIndex;
var nextBlockViewIndex;
var currentRotationIndex;
var nextRotationIndex;
var nextColorIndex;
var currentColorIndex;
var currentLevel;
var gameScore;
var numLines;

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
		model.append({ value: 0, colorIndex: 0 });
		canvasState.push({ value: 0, colorIndex: 0 });
	}
}

this.initMovingTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		var value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.append({ value: value, colorIndex: currentColorIndex });
		movingBlockState.push({ value: value, colorIndex: currentColorIndex });
	}
}

this.initNextTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		model.append({ value: pieces[nextBlockViewIndex][nextRotationIndex] & bit, colorIndex: 0 });
	}
}

function init() {
	currentBlockViewIndex = randomBlockViewIndex();
	currentRotationIndex = randomRotationIndex();
	currentColorIndex = gameConsts.randomColorIndex();

	nextRotationIndex = randomRotationIndex();
	nextBlockViewIndex = randomBlockViewIndex();
	nextColorIndex = gameConsts.randomColorIndex();

	currentLevel = 1;
	gameScore = 0;
	numLines = currentLevel * 10;
}

this.setCurrentLevel = function(level) {
	currentLevel = level;
	numLines = numLines % 10 + level * 10;
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
	updateBlockState()
	this.updateBlockModel(model);
}

function updateBlockState() {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		movingBlockState[indexBlock].value =  pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		movingBlockState[indexBlock].colorIndex = currentColorIndex;
	}
}

this.updateBlockModel = function(model) {
	for (var idx = 0; idx < 16; ++idx)
	{
		model.set(idx, { value: movingBlockState[idx].value, colorIndex: movingBlockState[idx].colorIndex });
	}
}

this.updateNextTetraminos = function(model) {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		model.set(indexBlock, { value: pieces[nextBlockViewIndex][nextRotationIndex] & bit, colorIndex: nextColorIndex });
	}
}

this.restartGame = function(gameViewModel, blockViewModel, nextBlockViewModel) {
	this.clearCanvas(gameViewModel);
	init();

	this.updateMovingTetraminos(blockViewModel);
	this.updateNextTetraminos(nextBlockViewModel);

	return { score: gameScore, level: currentLevel };
}

this.clearCanvas = function(model) {
	for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.set(idx, { value: 0, colorIndex: 0 });
		canvasState[idx].value = 0;
		canvasState[idx].colorIndex = 0;
	}
}

this.parkBlock = function(x, y, model) {
	for (var k = 0; k < 16; ++k)
	{
		var blockX = x + (k % 4) * gameConsts.getBlockSize();
		var blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if (movingBlockState[k].value > 0)
		{
			canvasState[index(blockX, blockY)].value = movingBlockState[k].value;
			canvasState[index(blockX, blockY)].colorIndex = movingBlockState[k].colorIndex;
		}
	}
	checkLines();
	this.updateCanvasModel(model);

	return { score: gameScore, level: currentLevel };
}

this.updateCanvasModel = function(model) {
	for(var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.set(idx,{ value: canvasState[idx].value, colorIndex: canvasState[idx].colorIndex });
	}
}

function removeLine(idx) {
	for (var i = idx; i >= gameConsts.getGlassWidth(); --i)
	{
		canvasState[i].value = canvasState[i - gameConsts.getGlassWidth()].value;
		canvasState[i].colorIndex = canvasState[i - gameConsts.getGlassWidth()].colorIndex;
	}

	for ( i = 0; i < gameConsts.getGlassWidth(); ++i)
	{
		canvasState[i].value = 0;
		canvasState[i].colorIndex = 0;
	}
}

function calcScores(compeletedRowsNumber) {
	if (compeletedRowsNumber === 1)
	{
		gameScore += 100 * currentLevel;
	}
	else if (compeletedRowsNumber === 2)
	{
		gameScore += 300 * currentLevel;
	}
	else if (compeletedRowsNumber === 3)
	{
		gameScore += 700 * currentLevel;
	}
	else if (compeletedRowsNumber === 4)
	{
		gameScore += 1500 * currentLevel;
	}

	numLines += compeletedRowsNumber;
	currentLevel = Math.floor(numLines / 10);
}

function checkLines() {
	var completedRowsCounter = 0;
	do
	{
		var checkAgain = false;
		var blockCounter = 0;
		for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
		{
			if (canvasState[idx].value > 0)
			{
				++blockCounter;
			}

			if ((idx + 1) % gameConsts.getGlassWidth() == 0)
			{
				if (blockCounter === gameConsts.getGlassWidth())
				{
					removeLine(idx);
					checkAgain = true;
					++completedRowsCounter;
					break;
				}

				blockCounter = 0;
			}
		}
	} while (checkAgain === true);

	calcScores(completedRowsCounter);
}

this.tryRotate = function(x, y, model) {
	var rotationIndex = currentRotationIndex;
	currentRotationIndex = (currentRotationIndex === 3 ? 0 : currentRotationIndex + 1);
	updateBlockState();
	if (!this.hasColllisions(x,y))
	{
		this.updateBlockModel(model);
		this.updateProperties(x, y, model)
	}
	else
	{
		currentRotationIndex = rotationIndex;
		updateBlockState();
	}
}

this.hasColllisions = function(x, y) {
	if (hasBorderCollisions(x, y) || hasCanvasCollisions(x, y))
	{
		return true;
	}

	return false;
}

this.updateProperties = function(x, y, model) {
	for (var k = 0; k < 16; ++k)
	{
		var blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		var blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if (blockX < 0 || blockX >= gameConsts.getGameWidth() || blockY >= gameConsts.getGameHeight())
		{
			movingBlockState[k].value = -1;
			model.set(k, { value: -1 });
		}
		else if (movingBlockState[k].value === -1)
		{
			movingBlockState[k].value = 0;
			model.set(k, { value: 0 });
		}
	}
}

function hasBorderCollisions(x, y) {
	for (var k = 0; k < 16; ++k)
	{
		var blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		var blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if ((blockX < 0 || blockX >= gameConsts.getGameWidth() || blockY >= gameConsts.getGameHeight()) && movingBlockState[k].value > 0)
		{
			return true;
		}
	}

	return false;
}

function hasCanvasCollisions(x, y) {
	for (var k = 0; k < 16; ++k)
	{
		var blockX = x + (k % 4) * gameConsts.getBlockSize() ;
		var blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		if (movingBlockState[k].value > 0 && canvasState[index(blockX, blockY)].value > 0)
		{
			return true;
		}
	}

	return false;
}

function randomBlockViewIndex() {
	return Math.floor(Math.random() * 7);
}

function randomRotationIndex() {
	return Math.floor(Math.random() * 4);
}

function index(x, y) {
	return Math.floor(y / gameConsts.getBlockSize()) * gameConsts.getGlassWidth() + Math.floor(x / gameConsts.getBlockSize());
}

function setProperties() {
	currentBlockViewIndex = nextBlockViewIndex;
	currentRotationIndex = nextRotationIndex;
	currentColorIndex = nextColorIndex;

	nextBlockViewIndex = randomBlockViewIndex();
	nextRotationIndex = randomRotationIndex();
	nextColorIndex = gameConsts.randomColorIndex();
}
