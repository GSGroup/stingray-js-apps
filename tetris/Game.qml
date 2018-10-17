import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "InfoRect.qml";
import "PauseRect.qml";
import "Cell.qml";

import "MenuDelegate.qml";
import "LevelDelegate.qml";
import "CanvasItemDelegate.qml";

import "engine.js" as engine;

Rectangle{
	id: mainWindow;

	width: safeArea.width;
	height: safeArea.height;

	focus: true;
	color: colorTheme.globalBackgroundColor;

	visible: true;

	Rectangle {
		id: game;

		property int glassWidth: 10;
		property int glassHigh: 20;

		property int dropTime: 16000;

		property int space: 6;
		property int spaceBetweenBlocks: 1 ;
		property int blockSize: (safeArea.height - space * 4) / glassHigh;

		property int currentBlock: 0x0F00;
		property int nextBlock: 0x4460;

		property int currentBlockViewIndex: 0;
		property int nextBlockViewIndex: 1;
		property int currentRotationIndex: 0;
		property int nextRotationIndex: 1;

		property int nextBlockColor: 0;
		property int currentBlockColor: 1;

		property int directionX: 0;
		property int directionY: 0;

		property int stepSize: game.blockSize;

		width: blockSize * glassWidth;
		height: blockSize * glassHigh;

		anchors.centerIn: parent;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		ListModel {
			id: gameCanvasModel;

			property int value;
			property string gradientStartColor;
			property string gradientStopColor;
		}

		GridView
		{
			id: gameView;

			property int numCells: game.glassHigh * game.glassWidth;

			anchors.fill: parent;

			width: game.width;
			height : game.height;

			cellWidth: game.blockSize;
			cellHeight: game.blockSize;

			orientation: GridView.Vertical;

			model: gameCanvasModel;

			delegate: CanvasItemDelegate { }

			onCompleted: {
				for(var i = 0; i < gameView.numCells; i++)
					gameCanvasModel.append({value: 0, gradientStartColor: "#E49C8B", gradientStopColor: "#CE573D",});
			}
		}

		Item {
			id: movingTetraminos;

			property real startPointX: game.width / 2 - rect.width * 2;

			x: startPointX;
			y: 0;

			focus: true;

			visible: true;

			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }

			Timer {
				id: animTimer;

				interval: game.dropTime / (game.glassHigh - 4);
				running: true;
				repeat: true;

				onTriggered: {
					if(!game.moveBlock(0,game.stepSize)) {
						//game.makeBlockPartOfCanvas();
						game.initNewMovingBlock();
					}
				}
			}

			onKeyPressed: {
				switch (key) {
					case 'Right':
						game.directionX = 1;
						game.directionY = 0;
						break;
					case 'Left':
						game.directionX = -1;
						game.directionY = 0;
						break;
					case 'Down':
						game.directionX = 0;
						game.directionY = 1;
						break;
					case 'Up':
						game.rotate();
						game.drawMovingBlock();
						game.directionX = 0;
						game.directionY = 0;
						break;
					default: return false;
				}
				game.moveBlock(game.directionX * game.stepSize,game.directionY * game.stepSize);

				return true;
			}

			onCompleted: {
				movingTetraminos.initMovingBlockCoord();

				game.drawMovingBlock();
			}

			function initMovingBlockCoord() {
				for (var k = 0; k < 16; ++k) {
					this.children[k].rect.color = game.color;
					this.children[k].rect.x = (k % 4) * game.blockSize ;
					this.children[k].rect.y = Math.floor(k / 4) * game.blockSize;

					this.children[k].innerRect.blockGradient.blockGradientStart.color = engine.getGradientStart(game.currentBlockColor);
					this.children[k].innerRect.blockGradient.blockGradientEnd.color = engine.getGradientEnd(game.currentBlockColor);
				}
			}
		}

		InfoRect {
			id: infoRect;

			width: parent.width;
			height: parent.height;

			anchors.top: parent.top;
			anchors.left: parent.right;
			anchors.leftMargin: game.blockSize * 3;

			color: colorTheme.globalBackgroundColor;

			visible: true;
		}

		ExitMenu {
			id: exitMenu;

			width: 0;
			height: game.blockSize * 4;

			anchors.centerIn: parent;

			focus: true;
			color: colorTheme.backgroundColor;
			clip: true;

			visible: false;

			function show() {
				exitMenu.width = game.width;
				exitMenu.visible = true;

				exitGrid.currentIndex = 0;
				exitMenu.setFocus();

				animTimer.stop();
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: 0;
			height: game.blockSize * 4.5;

			anchors.centerIn: parent;

			focus: true;
			color: "#000000";

			visible: false;

			function show() {
				gameOverMenu.width = game.width;
				gameOverMenu.visible = true;

				gameOverGrid.currentIndex = 0;
				gameOverGrid.setFocus();

				animTimer.stop();
			}
		}

		LevelMenu {
			id: levelMenu;

			width: 0;
			height: game.blockSize * 3;

			anchors.centerIn: parent;

			focus: true;
			color: colorTheme.backgroundColor;
			clip: true;

			visible: false;

			function show() {
				levelMenu.width = game.width;
				levelMenu.visible = true;

				levelGrid.setFocus();
				levelGrid.currentIndex = 0;

				animTimer.stop();
			}
		}

		PauseRect {
			id: pauseRect;

			width: game.width;
			height: game.blockSize * 6 + game.space * 4;

			anchors.centerIn: parent;

			focus: true;
			color: colorTheme.backgroundColor;

			visible: false;

			function show() {
				pauseRect.visible = true;
				pauseRect.setFocus();

				animTimer.stop();
			}
		}

		onKeyPressed: {
			if (key === "Select") {
				exitMenu.show();
				return true;
			}

			if (key === "8") {
				pauseRect.show();
				return true;
			}

			if (key === "7") {
				levelMenu.show();
				return true;
			}

			if (key === "6") {
				gameOverMenu.show();
				return true;
			}
			return true;
		}

		function getNewColor() {
			this.nextBlockColor = engine.randomColor();
		}

		function getNewBlock() {
			game.nextBlockViewIndex = Math.floor(Math.random() * 7);
			game.nextRotationIndex  = Math.floor(Math.random() * 4);

			this.nextBlock = engine.getBlock(game.nextBlockViewIndex,game.nextRotationIndex);
		}

		function drawNextBlockView() {
			for (var i = 0; i< 16; ++i)
			{
				nextTetraminos.children[i].innerRect.blockGradient.blockGradientStart.color = engine.getGradientStart(game.nextBlockColor);
				nextTetraminos.children[i].innerRect.blockGradient.blockGradientEnd.color = engine.getGradientEnd(game.nextBlockColor);
			}

			var bit;
			var indexBlock = 0;
			for (bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
				if (game.nextBlock & bit) {
					nextTetraminos.children[indexBlock].rect.value = 1;
				}
				else
				{
					nextTetraminos.children[indexBlock].rect.value = 0;
				}
				indexBlock++;
			}
		}
		function drawMovingBlock() {
			var bit;
			var indexBlock = 0;
			for (bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
				if (game.currentBlock & bit) {
					movingTetraminos.children[indexBlock].rect.value = 1;
				}
				else
				{
					movingTetraminos.children[indexBlock].rect.value = 0;
				}
				indexBlock++;
			}
		}

		function getBlock(x,y) {
			var indx = y / game.blockSize * game.glassWidth + x / game.blockSize;

			if(gameCanvasModel.get(indx).value === 1)
				return true;

			return false;
		}

		function hasCollisions(x,y) {
			var result = false;

			if ((x < 0) || (x >= game.width) || (y >= game.height) /*|| game.getBlock(x,y)*/){
				result = true;
			}

			return result;
		}

		function moveBlock(deltaX, deltaY) {
			var result = true;

			for (var j = 0; j < 16; ++j) {
				var x = movingTetraminos.children[j].rect.x;
				var y = movingTetraminos.children[j].rect.y;

				x += movingTetraminos.startPointX;

				if (game.hasCollisions(x + deltaX, y + deltaY))
					result = false;
			}

			if (result) {
				for (var i = 0; i < 16 ; ++i) {
					movingTetraminos.children[i].rect.x += deltaX;
					movingTetraminos.children[i].rect.y += deltaY;
				}
			}
			return result;
		}

		function rotate() {
			game.currentRotationIndex = (game.currentRotationIndex == 3 ? 0 : game.currentRotationIndex + 1);
			game.currentBlock = engine.getBlock(game.currentBlockViewIndex,game.currentRotationIndex);
		}

		function initNewMovingBlock() {
			game.currentBlock = game.nextBlock;
			game.currentBlockColor = game.nextBlockColor;

			game.currentBlockViewIndex = game.nextBlockViewIndex;
			game.currentRotationIndex  = game.nextRotationIndex;

			game.getNewBlock();
			game.getNewColor();
			game.drawNextBlockView();

			movingTetraminos.initMovingBlockCoord();
			game.drawMovingBlock();

			animTimer.restart();
		}

		function makeBlockPartOfCanvas() {
			for (var i = 0; i < 16; ++i) {
				var x = movingTetraminos.children[i].rect.x;
				var y = movingTetraminos.children[i].rect.y;
				var indx = y / game.blockSize * game.glassWidth + x / game.blockSize;
				var value = movingTetraminos.children[i].rect.value;

				if (value) {
					gameCanvasModel.setProperty(indx,'value',value);

					var colorGradientStart = engine.getGradientStart(game.currentBlockColor);
					var colorGradientStop  = engine.getGradientEnd(game.currentBlockColor);

					gameCanvasModel.setProperty(indx,'gradientStartColor',colorGradientStart);
					gameCanvasModel.setProperty(indx,'gradientStopColor',colorGradientStop);
				}
			}
		}
	}
}
