// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

var gameConsts = require("tetris", "generatedfiles/tetrisConsts.js");

var currentBlockViewIndex;
var nextBlockViewIndex;
var currentRotationIndex;
var nextRotationIndex;
var nextColorIndex;
var currentColorIndex;
var currentLevel;
var currentPieceOffset;
var currentPositionX;
var currentPositionY;
var startPositionX = 3;
var afterRotationPositionX;
var gameScore;
var numLines;
var completedRowsNumber = 0;
var blockSize = gameConsts.getBlockSize() - gameConsts.getSpaceBetweenBlocks() * 2;
var lastOccupiedBlockIndex;

var pieces =[
	[0x2640, 0x0630, 0x0264, 0x0630],
	[0x4620, 0x0360, 0x0462, 0x0360],
	[0x0660, 0x0660, 0x0660, 0x0660],
	[0x0F00, 0x2222, 0x0F00, 0x2222],
	[0x2620, 0x0270, 0x4640, 0x0720],
	[0x4460, 0x0740, 0x6220, 0x0170],
	[0x2260, 0x0470, 0x6440, 0x0710]
];

var piecesOffsetY = [
	[-3, -3, -4, -3],
	[-3, -3, -4, -3],
	[-3, -3, -3, -3],
	[-2, -4, -2, -4],
	[-3, -3, -3, -3],
	[-3, -3, -3, -3],
	[-3, -3, -3, -3]
];

var blocks = [];
var canvasState = [];
var movingBlockState = [];
var afterRotationBlockState = [];
var deletedLines = [];

var map = new Map();

this.leftDirection = 0;
this.downDirection = 1;
this.rightDirection = 2;

this.registrationInMap = function(id, object) {
	map.set(id, object);
}

function initCanvas() {
	for (var y = 0; y < gameConsts.getGlassWidth(); y++)
	{
		for (var x = 0; x < gameConsts.getGlassHeight(); x++)
		{
			canvasState.push({ occupied: false, colorIndex: gameConsts.getGlassColorIndex() });
		}
	}
}

function initMovingTetraminos() {
	for (var bit = 0x8000; bit > 0; bit = bit >> 1)
	{
		var value = pieces[currentBlockViewIndex][currentRotationIndex] & bit;
		movingBlockState.push({ occupied: !!value, colorIndex: currentColorIndex });
		afterRotationBlockState.push({ occupied: false });
	}
}

function initNextTetraminos(model) {
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

this.setNewBlock = function(nextBlockViewModel) {
	setProperties();
	this.setStartCoordinates();
	updateNextTetraminos(nextBlockViewModel);
}

function getPieceOffsetY() {
	return piecesOffsetY[currentBlockViewIndex][currentRotationIndex];
}

this.initGame = function(nextBlockViewModel) {
	init();
	initCanvas();
	initMovingTetraminos();
	initNextTetraminos(nextBlockViewModel);
}

this.setStartCoordinates = function() {
	currentPositionX = startPositionX;
	currentPositionY = getPieceOffsetY();
}

function repaintRectangle(y, x, color) {
	return map.get(y + "/" + x).colorIndex = color;
}

function recolorCurrentBlockPosition(color) {
	for (var y = 0; y < 4; y++)
	{
		for (var x = 0; x < 4; x++)
		{
			if ((movingBlockState[y * 4 + x].occupied) && ((currentPositionY + y) >= 0))
			{
				canvasState[index(currentPositionY + y, currentPositionX + x)].colorIndex = color;
				repaintRectangle(currentPositionY + y, currentPositionX + x, color);
			}
		}
	}
}

this.tryStep = function(direction) {
	var positionX = currentPositionX + direction - 1;
	var positionY = currentPositionY + (direction % 2);

	for (var y = 0; y < 4; y++)
	{
		for (var x = 0; x < 4; x++)
		{
			if (movingBlockState[y * 4 + x].occupied &&
				(((y + positionY) >= gameConsts.getGlassHeight()) ||
					((x + positionX) < 0) ||
					((x + positionX) >= gameConsts.getGlassWidth()) ||
					(((y + positionY) >= 0) && canvasState[index(y + positionY, x + positionX)].occupied)))
			{
				return false;
			}
		}
	}
	return true;
}

this.doStep = function(direction) {
	recolorCurrentBlockPosition(gameConsts.getGlassColorIndex());
	currentPositionX += direction - 1;
	currentPositionY += direction % 2;
	recolorCurrentBlockPosition(currentColorIndex);
}

function updateAfterRotationBlockState()
{
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		afterRotationBlockState[indexBlock].occupied = !!(pieces[currentBlockViewIndex][currentRotationIndex === 3 ? 0 : currentRotationIndex + 1] & bit);
	}
}

this.tryRotation = function() {
	updateAfterRotationBlockState();
	afterRotationPositionX = currentPositionX;

	var satisfactoryPositionX;
	do
	{
		satisfactoryPositionX = true;
		for (var y = 0; y < 4; y++)
		{
			for (var x = 0; x < 4; x++)
			{
				if (afterRotationBlockState[y * 4 + x].occupied)
				{
					if (((y + currentPositionY) >= gameConsts.getGlassHeight()) ||
						(((y + currentPositionY) >= 0) && canvasState[index(y + currentPositionY, x + afterRotationPositionX)].occupied))
					{
						return false;
					}

					if ((x + afterRotationPositionX) >= gameConsts.getGlassWidth())
					{
						afterRotationPositionX--;
						satisfactoryPositionX = false;
					}
					else if ((x + afterRotationPositionX) < 0)
					{
						afterRotationPositionX++;
						satisfactoryPositionX = false;
					}
				}
			}
		}
	} while (!satisfactoryPositionX)
	return true;
}

this.doRotation = function() {
	recolorCurrentBlockPosition(gameConsts.getGlassColorIndex());
	currentRotationIndex = currentRotationIndex === 3 ? 0 : currentRotationIndex + 1;
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		movingBlockState[indexBlock].occupied = !!(pieces[currentBlockViewIndex][currentRotationIndex] & bit);
	}
	currentPositionX = afterRotationPositionX;
	recolorCurrentBlockPosition(currentColorIndex);
}

this.writeToCanvas = function() {
	for (var y = 0; y < 4; y++)
	{
		for (var x = 0; x < 4; x++)
		{
			if (movingBlockState[y * 4 + x].occupied)
			{
				if ((y + currentPositionY) < 0)
				{
					return false;
				}
				canvasState[index(y + currentPositionY, x + currentPositionX)].occupied = true;
			}
		}
	}
	return true;
}

this.checkFullLines = function() {
	var isFullLine = true;
	for (var y = 0; y < gameConsts.getGlassHeight(); y++)
	{
		for (var x = 0; x < gameConsts.getGlassWidth(); x++)
		{
			if (!canvasState[index(y, x)].occupied)
			{
				isFullLine = false;
			}
		}
		if (isFullLine)
		{
			deletedLines.push(y);
		}
		isFullLine = true;
	}
	return !!deletedLines.length;
}

function changeAnimationProperties(y, x, borderWidth, duration) {
	map.get(y + "/" + x).borderWidthAnimation.duration = duration;
	map.get(y + "/" + x).borderWidth = borderWidth;
}

this.setRemoveLinesAnimation = function() {
	for (var y = 0; y < deletedLines.length; y++)
	{
		for (var x = 0; x < gameConsts.getGlassWidth(); x++)
		{
			changeAnimationProperties(deletedLines[y], x, Math.ceil(gameConsts.getBlockSize() / 2), 300);
		}
	}
}

this.resetRemoveLinesAnimation = function() {
	for (var y = 0; y < deletedLines.length; y++)
	{
		for (var x = 0; x < gameConsts.getGlassWidth(); x++)
		{
			changeAnimationProperties(deletedLines[y], x, gameConsts.getBorderSize(), 0);
		}
	}
}

function updateBlockState() {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		movingBlockState[indexBlock].occupied = !!(pieces[currentBlockViewIndex][currentRotationIndex] & bit);
		movingBlockState[indexBlock].colorIndex = currentColorIndex;
	}
}

function updateNextTetraminos(model) {
	for (var bit = 0x8000, indexBlock = 0; bit > 0; bit = bit >> 1, ++indexBlock)
	{
		model.setProperty(indexBlock, "value", pieces[nextBlockViewIndex][nextRotationIndex] & bit);
		model.setProperty(indexBlock, "colorIndex", nextColorIndex);
	}
}

this.restartGame = function(nextBlockViewModel) {
	clearCanvas();

	init();
	initCanvas();

	updateBlockState();
	updateNextTetraminos(nextBlockViewModel);

	return { score: gameScore, level: currentLevel };
}

function clearCanvas() {
	canvasState = [];
	for (var y = 0; y < gameConsts.getGlassHeight(); y++)
	{
		for (var x = 0; x < gameConsts.getGlassWidth(); x++)
		{
			repaintRectangle(y, x, gameConsts.getGlassColorIndex());
		}
	}
}

this.removeLines = function() {
	for (var lines = deletedLines.length - 1; lines >= 0; lines--)
	{
		for (var y = deletedLines[lines]; y > 0; y--)
		{
			for (var x = 0; x < gameConsts.getGlassWidth(); x++)
			{
				canvasState[index(y, x)].colorIndex = canvasState[index(y - 1, x)].colorIndex;
				canvasState[index(y, x)].occupied = canvasState[index(y - 1, x)].occupied;
				repaintRectangle(y, x, canvasState[index(y, x)].colorIndex);
			}
		}
		for (var i = 0; i < deletedLines.length; i++)
		{
			deletedLines[i]++;
		}
	}
	deletedLines = [];
	for (x = 0; x < gameConsts.getGlassWidth(); x++)
	{
		canvasState[index(0, x)].colorIndex = gameConsts.getGlassColorIndex();
		canvasState[index(0, x)].occupied = false;
		repaintRectangle(0, x, gameConsts.getGlassColorIndex());
	}
}

this.getInfo = function() {
	completedRowsNumber = deletedLines.length;
	calcScores();

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

function randomBlock() {
	if (blocks.length === 0)
	{
		blocks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27];
	}

	var index = blocks.splice(Math.floor(Math.random() * blocks.length), 1)[0];

	return { blockViewIndex: Math.floor(index / 4), rotationIndex: index % 4 }
}

function index(y, x) {
	return (y * gameConsts.getGlassWidth() + x);
}

function setProperties() {
	currentBlockViewIndex = nextBlockViewIndex;
	currentRotationIndex = nextRotationIndex;
	currentColorIndex = nextColorIndex;

	var nextBlock = randomBlock();
	nextBlockViewIndex = nextBlock.blockViewIndex;
	nextRotationIndex = nextBlock.rotationIndex;
	nextColorIndex = gameConsts.randomColorIndex();
	updateBlockState();
}