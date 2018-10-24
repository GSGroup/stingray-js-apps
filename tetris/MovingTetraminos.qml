import "tetrisConsts.js" as gameConsts

Item {
	id: movingItem;

	focus: true;

	visible: true;

	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }

	function getBlockCoorX(index) {
		return this.children[index].x;
	}

	function getBlockCoorY(index) {
		return this.children[index].y;
	}

	function initMovingBlockCoord() {
		for (var k = 0; k < 16; ++k) {
			this.children[k].x = (k % 4) * game.blockSize ;
			this.children[k].y = Math.floor(k / 4) * game.blockSize;

			this.children[k].color = game.color;
			this.children[k].blockColor = game.currentBlockColor;
		}
	}

	function moveBlock(deltaX, deltaY) {
		for (var i = 0; i < 16; ++i) {
			this.children[i].x += deltaX;
			this.children[i].y += deltaY;
		}
	}

	function drawMovingBlock(blockView) {
		var bit;
		var indexBlock = 0;
		for (bit = 0x8000; bit > 0; bit = bit >> 1) {
			this.children[indexBlock].value = blockView & bit;
			++indexBlock;
		}
	}

	function setMovingBlockView(blockView, blockColorIndex, backColor) {
		if(backColor === undefined) {
			backColor = colorTheme.backgroundColor;
		}
		for (var k = 0; k < 16; ++k) {
			movingItem.children[k].x = (k % 4) * gameConsts.getBlockSize() ;
			movingItem.children[k].y = Math.floor(k / 4) * gameConsts.getBlockSize();

			movingItem.children[k].color = backColor;
			movingItem.children[k].blockColorIndex = blockColorIndex;
		}

		this.updateBlockView(blockView);
	}
}
