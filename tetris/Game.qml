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

		property int space: 6;
		property int spaceBetweenBlocks: 1;
		property int blockSize: (safeArea.height - space * 4) / game.glassHigh;

		property int dropTime: 16000;
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

		GridView {
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
				for (var i = 0; i < gameView.numCells; i++)
					gameCanvasModel.append({value: 0, gradientStartColor: "#E49C8B", gradientStopColor: "#CE573D",});
			}
		}

		MovingTetraminos {
			id: movingTetraminos;

			property real startPointX: game.width / 2 - game.blockSize * 2;

			x: startPointX;
			y: 0;

			focus: true;

			visible: true;
		}

		Timer {
			id: animTimer;

			interval: game.dropTime / (game.glassHigh - 4);
			running: true;
			repeat: true;

			onTriggered: {
				if (!movingTetraminos.moveBlock(0,game.stepSize)) {
					game.initNewMovingBlock();
				}
			}
		}

		InfoRect {
			id: infoItem;

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
		}

		GameOverMenu {
			id: gameOverMenu;

			width: 0;
			height: game.blockSize * 4.5;

			anchors.centerIn: parent;

			focus: true;
			color: "#000000";

			visible: false;
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
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: game.blockSize * 6 + game.space * 4;

			anchors.centerIn: parent;

			focus: true;
			color: colorTheme.backgroundColor;

			visible: false;
		}

		onKeyPressed: {
			if (key == "Select") {
				animTimer.stop();
				exitMenu.show(game.width);
				return true;
			}

			if (key == "8") {
				animTimer.stop();
				pauseMenu.show();
				return true;
			}

			if (key == "7") {
				animTimer.stop();
				levelMenu.show(game.width);
				return true;
			}

			if (key == "6") {
				animTimer.stop();
				gameOverMenu.show(game.width);
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

			game.nextBlock = engine.getBlock(game.nextBlockViewIndex,game.nextRotationIndex);
		}

		function getBlock(x,y) {
			var indx = game.index(x,y);

			if (gameCanvasModel.get(indx).value == 1)
				return true;

			return false;
		}

		function hasCollisions(x,y) {
			var result = false;

			if ((x < 0) || (x >= game.width) || (y >= game.height) || game.getBlock(x,y)){
				result = true;
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

			infoItem.drawNextBlockView(game.nextBlockColor,game.nextBlock);

			movingTetraminos.initMovingBlockCoord();
			movingTetraminos.drawMovingBlock(game.currentBlock);

			animTimer.restart();
		}

		function makeBlockPartOfCanvas() {
			for (var i = 0; i < 16; ++i) {
				var indx = game.index(movingTetraminos.children[i].x,movingTetraminos.children[i].y);
				var value = movingTetraminos.children[i].value;

				if (value) {
					gameCanvasModel.setProperty(indx,'value',value);

					var colorGradientStart = engine.getGradientStart(game.currentBlockColor);
					var colorGradientStop  = engine.getGradientEnd(game.currentBlockColor);

					gameCanvasModel.setProperty(indx,'gradientStartColor',colorGradientStart);
					gameCanvasModel.setProperty(indx,'gradientStopColor',colorGradientStop);
				}
			}
		}

		function index(x, y){
			var indx = Math.floor(y / game.blockSize) * game.glassWidth + Math.floor(x / game.blockSize);
			return indx;
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

			infoItem.drawNextBlockView(game.nextBlockColor,game.nextBlock);
		}
	}
}
