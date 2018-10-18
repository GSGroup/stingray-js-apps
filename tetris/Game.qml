import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "InfoRect.qml";
import "PauseRect.qml";
import "Cell.qml";
import "MovingTetraminos.qml";

import "MenuDelegate.qml";
import "LevelDelegate.qml";
import "CanvasItemDelegate.qml";

import "engine.js" as engine;

Rectangle{
	id: mainScreen;

	width: safeArea.width;
	height: safeArea.height;

	focus: true;
	color: colorTheme.globalBackgroundColor;

	Rectangle {
		id: game;

		property int glassWidth: 10;
		property int glassHigh: 20;

		property int space: 6;
		property int spaceBetweenBlocks: 1;
		property int blockSize: (safeArea.height - space * 4) / game.glassHigh;

		property int dropTime: 16000;
		property int stepSize: game.blockSize;

		width: blockSize * glassWidth;
		height: blockSize * glassHigh;

		anchors.centerIn: mainWindow;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		ListModel {
			id: gameCanvasModel;

			property int value;
			property string gradientStartColor;
			property string gradientStopColor;
		}

		GridView {
			id: gameView;

			width: game.width;
			height : game.height;

			orientation: GridView.Vertical;

			model: gameCanvasModel;
			delegate: CanvasItemDelegate { }

			onCompleted: {
				for (var i = 0; i < game.glassHigh * game.glassWidth; ++i)
					gameCanvasModel.append({value: 0, gradientStartColor: "#E49C8B", gradientStopColor: "#CE573D",});
			}
		}

		MovingTetraminos {
			id: movingTetraminos;

			x: game.width / 2 - game.blockSize * 2;
			y: 0;
		}

		Timer {
			id: animTimer;

			interval: game.dropTime / (game.glassHigh - 4);
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!movingTetraminos.moveBlock(0, game.stepSize)) {
					game.initNewMovingBlock();
				}
			}
		}

		InfoRect {
			id: infoItem;

			width: game.width;
			height: game.height;

			anchors.left: game.right;
			anchors.leftMargin: game.blockSize * 3;
		}

		ExitMenu {
			id: exitMenu;

			width: game.width;
			height: game.blockSize * 4;

			anchors.centerIn: game;
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: game.blockSize * 4.5;

			anchors.centerIn: game;
		}

		LevelMenu {
			id: levelMenu;

			width: game.width;
			height: game.blockSize * 3;

			anchors.centerIn: game;
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: game.blockSize * 6 + game.space * 4;

			anchors.centerIn: game;
		}

		onKeyPressed: {
			if (key === "Select") {
				exitMenu.show();
				return true;
			}

			if (key === "8") {
				pauseMenu.show();
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
			game.nextBlockColor = engine.randomColor();
		}

		function getNewBlock() {
			game.nextBlockViewIndex = Math.floor(Math.random() * 7);
			game.nextRotationIndex  = Math.floor(Math.random() * 4);

			game.nextBlock = engine.getBlock(game.nextBlockViewIndex, game.nextRotationIndex);
		}

		function getBlock(x,y) {
			var indx = game.index(x,y);

			if (gameCanvasModel.get(indx).value == 1)
				return true;

			return false;
		}

		function hasCollisions(x,y) {
			var result = false;

			if ((x < 0) || (x >= game.width) || (y >= game.height) || game.getBlock(x,y)) {
				result = true;
			}

			return result;
		}

		function rotate() {
			game.currentRotationIndex = (game.currentRotationIndex == 3 ? 0 : game.currentRotationIndex + 1);
			game.currentBlock = engine.getBlock(game.currentBlockViewIndex, game.currentRotationIndex);
		}

		function initNewMovingBlock() {
			game.currentBlock = game.nextBlock;
			game.currentBlockColor = game.nextBlockColor;

			game.currentBlockViewIndex = game.nextBlockViewIndex;
			game.currentRotationIndex  = game.nextRotationIndex;

			game.getNewBlock();
			game.getNewColor();

			infoItem.drawNextBlockView(game.nextBlockColor, game.nextBlock);

			movingTetraminos.initMovingBlockCoord();
			movingTetraminos.drawMovingBlock(game.currentBlock);

			animTimer.restart();
		}

		function makeBlockPartOfCanvas() {
			for (var i = 0; i < 16; ++i) {
				var indx = game.index(movingTetraminos.children[i].x, movingTetraminos.children[i].y);
				var value = movingTetraminos.children[i].value;

				if (value) {
					gameCanvasModel.setProperty(indx,'value',value);

					var colorGradientStart = engine.getGradientStart(game.currentBlockColor);
					var colorGradientStop  = engine.getGradientEnd(game.currentBlockColor);

					gameCanvasModel.setProperty(indx, 'gradientStartColor', colorGradientStart);
					gameCanvasModel.setProperty(indx, 'gradientStopColor', colorGradientStop);
				}
			}
		}

		function index(x, y) {
			return (Math.floor(y / game.blockSize) * game.glassWidth + Math.floor(x / game.blockSize));
		}

		onCompleted: {
			game.currentBlock = 0x0F00;
			game.nextBlock = 0x4460;

			game.currentBlockViewIndex = 0;
			game.nextBlockViewIndex = 1;
			game.currentRotationIndex = 0;
			game.nextRotationIndex = 1;

			game.nextBlockColor = 0;
			game.currentBlockColor = 1;

			game.directionX = 0;
			game.directionY = 0;

			movingTetraminos.initMovingBlockCoord();
			movingTetraminos.drawMovingBlock(game.currentBlock);

			infoItem.drawNextBlockView(game.nextBlockColor, game.nextBlock);
		}
	}
}
