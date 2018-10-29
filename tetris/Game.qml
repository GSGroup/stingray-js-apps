import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "PauseRect.qml";
import "ItemGridView.qml";

import "engine.js" as engine;
import "tetrisConsts.js" as gameConsts;

Rectangle{
	id: mainScreen;

	width: safeArea.width;
	height: safeArea.height;

	focus: true;
	color: colorTheme.globalBackgroundColor;

	Rectangle {
		id: game;

		property int space: 6;
		property int stepSize: gameConsts.getBlockSize();
		property int startX: gameConsts.getGameWidth() / 2 - gameConsts.getBlockSize() * 2;
		property int currentLevel: 1;
		property int gameScore: 0;
		property int dropTime: 16000;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainScreen;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		ItemGridView {
			id: gameView;

			width: game.width;
			height: game.height;
		}

		Item {
			id: movingTetraminos;

			x: game.startX;
			y: 0;

			width: gameConsts.getBlockSize() * 4;
			height: gameConsts.getBlockSize() * 4;

			focus: true;

			ItemGridView {
				id: blockView;

				width: gameConsts.getBlockSize() * 4;
				height: gameConsts.getBlockSize() * 4;
			}

			onSelectPressed: { engine.tryRotate(movingTetraminos.x, movingTetraminos.y, blockView.model); }

			onRightPressed: { this.move(1, 0); }

			onLeftPressed: { this.move(-1, 0); }

			onDownPressed: { this.move(0, 1); }

			function move(directionX, directionY) {
				var stepX = directionX * game.stepSize;
				var stepY = directionY * game.stepSize;
				if (!engine.hasColllisions(movingTetraminos.x + stepX, movingTetraminos.y + stepY))
				{
					movingTetraminos.x += stepX;
					movingTetraminos.y += stepY;
					engine.updateProperties(movingTetraminos.x, movingTetraminos.y, blockView.model);
				}
			}
		}

		Timer {
			id: animTimer;

			interval: game.dropTime / (gameConsts.getGlassHeight() - 4) / game.currentLevel;
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!engine.hasColllisions(movingTetraminos.x, movingTetraminos.y + game.stepSize))
				{
					movingTetraminos.y += game.stepSize;
					engine.updateProperties(movingTetraminos.x, movingTetraminos.y, blockView.model);
				}
				else
				{
					engine.parkBlock(movingTetraminos.x, movingTetraminos.y)
					game.updateInfo();
					engine.updateCanvasModel(gameView.model);
					engine.nextStep(blockView.model, nextBlockView.model);

					if(!engine.hasColllisions(game.startX, 0))
					{
						movingTetraminos.x = game.startX;
						movingTetraminos.y = 0;
					}
					else
					{
						movingTetraminos.visible = false;
						gameOverMenu.show();
					}
				}
			}
		}

		Rectangle {
			id: infoItem;

			width: game.width;
			height: game.height;

			anchors.left: game.right;
			anchors.leftMargin: gameConsts.getBlockSize() * 3;

			color: colorTheme.globalBackgroundColor;

			Item {
				id: nextTetraminos;

				width: gameConsts.getBlockSize() * 6;
				height: gameConsts.getBlockSize() * 6;

				color: colorTheme.globalBackgroundColor;

				ItemGridView {
					id: nextBlockView;

					x: gameConsts.getBlockSize();
					y: gameConsts.getBlockSize();

					width: gameConsts.getBlockSize() * 4;
					height: gameConsts.getBlockSize() * 4;
				}
			}

			SmallCaptionText {
				id: levelRect;

				anchors.top: nextTetraminos.bottom;
				anchors.leftMargin: gameConsts.getBlockSize();

				text: qsTr("Уровень ") + game.currentLevel;
				color: colorTheme.highlightPanelColor;
			}

			SmallCaptionText {
				id: scoreRect;

				anchors.top: levelRect.bottom;
				anchors.topMargin: gameConsts.getBlockSize();
				anchors.leftMargin: gameConsts.getBlockSize();

				text: qsTr("Счет    ") + game.gameScore;
				color: colorTheme.highlightPanelColor;
			}
		}

		ExitMenu {
			id: exitMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 4;

			anchors.centerIn: game;

			onBackToGame: {
				exitMenu.visible = false;
				movingTetraminos.setFocus();
			}

			onSetNewGame: {
				exitMenu.visible = false;
				game.setNewGame();
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 4;

			anchors.centerIn: game;

			onSetNewGame: {
				gameOverMenu.visible = false;
				game.setNewGame();
			}
		}

		LevelMenu {
			id: levelMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 3;

			anchors.centerIn: game;

			onLevelChanged: {
				levelRect.visible = false;
				movingTetraminos.setFocus();
				game.currentLevel = level;
				engine.setCurrentLevel(game.currentLevel);
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 6 + game.space * 4;

			anchors.centerIn: game;

			onContinueGame: {
				pauseRect.visible = false;
				movingTetraminos.setFocus();
			}
		}

		function updateInfo() {
			game.currentLevel = engine.getCurrentLevel();
			game.gameScore = engine.getGameScore();
		}

		function setNewGame() {
			movingTetraminos.setFocus();
			movingTetraminos.visible = true;
			movingTetraminos.x = game.startX;
			movingTetraminos.y = 0;

			engine.restartGame(gameView.model, blockView.model, nextBlockView.model);
			game.currentLevel = 1;
			game.gameScore = 0;
		}

		onUpPressed: { pauseMenu.show(); }

		onMenuPressed: { exitMenu.show(); }

		onExitPressed: { exitMenu.show(); }

		onLastPressed: { exitMenu.show(); }

		on7Pressed: { levelMenu.show(); }

		onCompleted: {
			engine.initGame(gameView.model, blockView.model, nextBlockView.model);
			movingTetraminos.setFocus();
		}
	}
}
