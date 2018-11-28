var gameConsts = require("tetris", "tetrisConsts.js");

var currentBlockViewIndex;
var nextBlockViewIndex;
var currentRotationIndex;
var nextRotationIndex;
var nextColorIndex;
var currentColorIndex;
var currentLevel;
var currentPieceOffset;
var gameScore;
var numLines;
var completedRowsNumber = 0;
var deleteInfo = { idx: -1, linesNumber: 0 };
var blockSize = gameConsts.getBlockSize() - gameConsts.getSpaceBetweenBlocks() * 2;
var lastOccupiedBlockIndex = gameConsts.getBlockNumber();

var pieces =[
	[0x44C0, 0x8E00, 0x6440, 0x0E20],
	[0x4460, 0x0E80, 0xC440, 0x2E00],
	[0xCC00, 0xCC00, 0xCC00, 0xCC00],
	[0x0F00, 0x2222, 0x00F0, 0x4444],
	[0x06C0, 0x8C40, 0x6C00, 0x4620],
	[0x0E40, 0x4C40, 0x4E00, 0x4640],
	[0x0C60, 0x4C80, 0xC600, 0x2640]
];

var piecesOffset = [
	[0, 0, 0, 1],
	[0, 1, 0, 0],
	[0, 0, 0, 0],
	[1, 0, 2, 0],
	[1, 0, 0, 0],
	[1, 0, 0, 0],
	[1, 0, 0, 0]
]

var blocks = [];
var canvasState = [];
var movingBlockState = [];

this.initCanvas = function(model) {
	for (var idx = 0; idx < gameConsts.getBlockNumber(); ++idx)
	{
		model.append({ value: 0, colorIndex: 0, width: blockSize, needAnim: false });
		canvasState.push({ value: 0, colorIndex: 0 });
	}
}

this.initMovingTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		var value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		model.append({ value: value, colorIndex: currentColorIndex, width: blockSize, needAnim: false });
		movingBlockState.push({ value: value, colorIndex: currentColorIndex });
	}
}

this.initNextTetraminos = function(model) {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		model.append({ value: pieces[nextBlockViewIndex][nextRotationIndex] & bit, colorIndex: nextColorIndex, width: blockSize, needAnim: false });
	}
}

function init() {
	var block = randomBlock();
	currentBlockViewIndex = block.blockViewIndex;
	currentRotationIndex = block.rotationIndex;
	currentColorIndex = gameConsts.randomColorIndex();

	block = randomBlock();
	nextBlockViewIndex = block.blockViewIndex;
	nextRotationIndex = block.rotationIndex;
	nextColorIndex = gameConsts.randomColorIndex();

	currentLevel = 1;
	gameScore = 0;
	numLines = currentLevel * 10;
}

this.setCurrentLevel = function(level) {
	currentLevel = level;
	numLines = numLines % 10 + level * 10;
}

this.getPieceOffset = function() {
	return piecesOffset[currentBlockViewIndex][currentRotationIndex] * gameConsts.getBlockSize();
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

this.zeroizeModelWidth = function(model)
{
	for (var idx = deleteInfo.idx; idx > deleteInfo.idx - gameConsts.getGlassWidth() * deleteInfo.linesNumber; --idx)
	{
		model.set(idx, { value: canvasState[idx].value, colorIndex: canvasState[idx].colorIndex, needAnim: true, width: 0 });
	}
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
		model.setProperty(idx, "value", movingBlockState[idx].value);
		model.setProperty(idx, "colorIndex", movingBlockState[idx].colorIndex);
	}
}

this.updateNextTetraminos = function(model) {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		model.setProperty(indexBlock, "value", pieces[nextBlockViewIndex][nextRotationIndex] & bit);
		model.setProperty(indexBlock, "colorIndex", nextColorIndex);
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
		model.set(idx, { value: 0, colorIndex: 0, width: blockSize, needdAnim: false });
		canvasState[idx].value = 0;
		canvasState[idx].colorIndex = 0;
	}
}

this.parkBlock = function(x, y, model) {
	completedRowsNumber = 0;
	for (var k = 0; k < 16; ++k)
	{
		var blockX = x + (k % 4) * gameConsts.getBlockSize();
		var blockY = y + Math.floor(k / 4) * gameConsts.getBlockSize();

		var blockIndex = index(blockX, blockY);

		if (movingBlockState[k].value > 0)
		{
			canvasState[blockIndex].value = movingBlockState[k].value;
			canvasState[blockIndex].colorIndex = movingBlockState[k].colorIndex;

			model.setProperty(blockIndex, "value", canvasState[blockIndex].value);
			model.setProperty(blockIndex, "colorIndex", canvasState[blockIndex].colorIndex);

			if (blockIndex < lastOccupiedBlockIndex)
			{
				lastOccupiedBlockIndex = blockIndex;
			}
		}
	}
}

this.updateCanvasModel = function(index, model) {
	model.set(index, { value: canvasState[index].value, colorIndex: canvasState[index].colorIndex, width: blockSize, needAnim: false });
}

this.removeLines = function(model) {
	for (var i = deleteInfo.idx; i >= lastOccupiedBlockIndex; --i)
	{
		var inGlass = lastOccupiedBlockIndex >= gameConsts.getGlassWidth() * deleteInfo.linesNumber;
		canvasState[i].value = inGlass ? canvasState[i - gameConsts.getGlassWidth() * deleteInfo.linesNumber].value : 0;
		canvasState[i].colorIndex = inGlass ? canvasState[i - gameConsts.getGlassWidth() * deleteInfo.linesNumber].colorIndex : 0;
		this.updateCanvasModel(i, model);
	}

	calcScores();

	deleteInfo.linesNumber = 0;
	deleteInfo.idx = -1;
	lastOccupiedBlockIndex -= gameConsts.getGlassWidth() * deleteInfo.linesNumber;

	return { score: gameScore, level: currentLevel };
}

function calcScores() {
	if (completedRowsNumber === 1)
	{
		gameScore += 100 * currentLevel;
	}
	else if (completedRowsNumber === 2)
	{
		gameScore += 300 * currentLevel;
	}
	else if (completedRowsNumber === 3)
	{
		gameScore += 700 * currentLevel;
	}
	else if (completedRowsNumber === 4)
	{
		gameScore += 1500 * currentLevel;
	}

	numLines += completedRowsNumber;
	currentLevel = Math.floor(numLines / 10);
}

this.checkLines = function() {
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
				++completedRowsNumber;
				++deleteInfo.linesNumber;
				deleteInfo.idx = idx;
			}
			else if (deleteInfo.linesNumber > 0)
			{
				break;
			}

			blockCounter = 0;
		}
	}

	return deleteInfo.linesNumber;
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
			model.setProperty(k, "value", -1);
		}
		else if (movingBlockState[k].value === -1)
		{
			movingBlockState[k].value = 0;
			model.setProperty(k, "value", 0);
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

function randomBlock() {
	if (blocks.length === 0)
	{
		blocks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27];
	}

	var index = blocks.splice(Math.floor(Math.random() * blocks.length), 1)[0];

	return { blockViewIndex: Math.floor(index / 4), rotationIndex: index % 4 }
}

function index(x, y) {
	return Math.floor(y / gameConsts.getBlockSize()) * gameConsts.getGlassWidth() + Math.floor(x / gameConsts.getBlockSize());
}

function setProperties() {
	currentBlockViewIndex = nextBlockViewIndex;
	currentRotationIndex = nextRotationIndex;
	currentColorIndex = nextColorIndex;

	var nextBlock = randomBlock();
	nextBlockViewIndex = nextBlock.blockViewIndex;
	nextRotationIndex = nextBlock.rotationIndex;
	nextColorIndex = gameConsts.randomColorIndex();
}
