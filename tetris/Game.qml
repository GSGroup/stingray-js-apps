import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "InfoRect.qml";
import "PauseRect.qml";
import "Cell.qml";
import "MovingTetraminos.qml";
import "MenuItem.qml";

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
			property int colorIndex;
		}

		GridView {
			id: gameView;

			width: game.width;
			height: game.height;

			orientation: GridView.Vertical;

			model: gameCanvasModel;
			delegate: CanvasItemDelegate { }

			onCompleted: {
				for (var i = 0; i < gameConsts.getGlassWidth() * gameConsts.getGlassHeight(); ++i)
					gameCanvasModel.append({ value: 0, colorIndex: 0 });
			}
		}

		MovingTetraminos {
			id: movingTetraminos;

			x: game.width / 2 - game.blockSize * 2;
			y: 0;

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
					engine.rotate();
					drawMovingBlock(engine.currentBlock);
					break;

				default: return false;
				}
			}

			function tryRotate()
			{
				return true;
			}

			function checkColllisions(deltaX, deltaY)
			{
				var result = false;
				for (var j = 0; j < 16; ++j) {
					if (engine.hasCollisions(this.getBlockCoorX(j) + movingTetraminos.x + deltaX, this.getBlockCoorY(j) + movingTetraminos.y + deltaY))
						result = true;
				}
			}
		}

		Timer {
			id: animTimer;

			interval: game.dropTime / (game.glassHigh - 4);
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!movingTetraminos.checkColllisions(0, game.stepSize)){
					movingTetraminos.moveBlock(0, game.stepSize);
				}
				else {
					game.nextStep();
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

			onBackToGame: {
				exitMenu.visible = false;
				movingTetraminos.setFocus();
			}

			onSetNewGame: {
				exitMenu.visible = false;
				movingTetraminos.setFocus();
				game.restartGame();
			}

			onKeyPressed: {
				if (key === "8" || key === "7" || key === "6") {
					return true;
				}
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 4;

			anchors.centerIn: game;

			onKeyPressed: {
				if (key === "8" || key === "7") {
					return true;
				}
			}

			onVisibleChanged: {
				if(!visible)
					movingTetraminos.setFocus();
			}
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
				var index = game.index(movingTetraminos.children[i].x, movingTetraminos.children[i].y);

				if (movingTetraminos.children[i].value) {
					gameCanvasModel.setProperty(index,'value',value);
					gameCanvasModel.setProperty(index, 'indexColor', engine.getCurrentColorIndex());
				}
			}
		}

		function nextStep() {
			engine.setMovingBlockProperties();
			movingTetraminos.setMovingBlockView(engine.getCurrentBlock(), engine.getCurrentColorIndex());
			infoItem.showNextBlockView(engine.getNextColorIndex(), engine.getNextBlock());
			animTimer.restart();
		}

		function clearCanvas() {

		}

		function restartGame() {
			game.clearCanvas();
			engine.init();
			movingTetraminos.setMovingBlockView(engine.getCurrentBlock(), engine.getCurrentColorIndex());
			infoItem.showNextBlockView(engine.getNextColorIndex(), engine.getNextBlock());
			animTimer.restart();
		}

		onCompleted: {
			engine.init();
			movingTetraminos.setMovingBlockView(engine.getCurrentBlock(), engine.getCurrentColorIndex());
			infoItem.showNextBlockView(engine.getNextColorIndex(), engine.getNextBlock());
		}
	}
}
