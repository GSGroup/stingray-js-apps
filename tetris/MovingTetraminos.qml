Item {
	id: movingItem;

	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }
	Cell { } Cell { } Cell { } Cell { }

	//FIXME:вынести во вне
	onKeyPressed: {
		var directionX = 0;
		var directionY = 0;

		switch (key) {
		case 'Right':
			directionX = 1;
			directionY = 0;
			break;
		case 'Left':
			directionX = -1;
			directionY = 0;
			break;
		case 'Down':
			directionX = 0;
			directionY = 1;
			break;
		case 'Up':
			directionX = 0;
			directionY = 0;

			game.rotate();
			this.drawMovingBlock(game.currentBlock);
			break;
		default: return false;
		}
		this.moveBlock(directionX * game.stepSize,directionY * game.stepSize);

		return true;
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
		var result = true;

		for (var j = 0; j < 16; ++j) {
			var x = this.children[j].x;
			var y = this.children[j].y;

			x += this.startPointX;

			if (game.hasCollisions(x + deltaX, y + deltaY))
				result = false;
		}

		if (result) {
			for (var i = 0; i < 16 ; ++i) {
				this.children[i].x += deltaX;
				this.children[i].y += deltaY;
			}
		}
		return result;
	}

	function drawMovingBlock(blockView) {
		var bit;
		var indexBlock = 0;
		for (bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
			if (blockView & bit) {
				this.children[indexBlock].value = 1;
			}
			else
			{
				this.children[indexBlock].value = 0;
			}
			indexBlock++;
		}
	}

}
