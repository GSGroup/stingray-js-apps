// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

var dropTime =16000;
var spaceBetweenBlocks = 1;
var glassWidth = 10;
var glassHeight = 17;
var blockSize = 35;
var gameWidth = blockSize * glassWidth;
var gameHeight = blockSize * glassHeight;
var blockNumber = glassHeight * glassWidth;
var COLORS = { GREEN: "#93AD00", BLUE: "#0090FF", ORANGE: "#FF6331", YELLOW: "#FFD200",	VELVET: "#D151BD" };

var colorCollection = [ COLORS.GREEN, COLORS.BLUE, COLORS.ORANGE, COLORS.YELLOW, COLORS.VELVET ];

this.randomColorIndex = function() {
	return Math.floor(Math.random() * colorCollection.length);
}

this.getDropTime = function() {
	return dropTime;
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
