import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "PauseRect.qml";
import "InfoRect.qml";
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
		property bool deletingLines: false;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainScreen;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		ItemGridView {
			id: gameView;

			animationDuration: animTimer.interval;

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

				visible: !(game.deletingLines || levelMenu.visible || gameOverMenu.visible);
			}

			onSelectPressed: {
				engine.tryRotate(movingTetraminos.x, movingTetraminos.y, blockView.model);
				engine.updateProperties(movingTetraminos.x, movingTetraminos.y, blockView.model);
			}

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
				if (game.deletingLines)
				{
					game.updateInfo(engine.removeLines(gameView.model));
					if (engine.checkLines() > 0)
					{
						engine.zeroizeModelWidth(gameView.model);
					}
					else
					{
						game.deletingLines = false;
						game.nextStep();
					}
				}
				else
				{
					if (!engine.hasColllisions(movingTetraminos.x, movingTetraminos.y + game.stepSize))
					{
						movingTetraminos.y += game.stepSize;
						engine.updateProperties(movingTetraminos.x, movingTetraminos.y, blockView.model);
					}
					else
					{
						engine.parkBlock(movingTetraminos.x, movingTetraminos.y, gameView.model);
						if (engine.checkLines() > 0)
						{
							game.deletingLines = true;
							engine.zeroizeModelWidth(gameView.model);
						}
						else
						{
							game.nextStep();
						}
					}
				}
			}
		}

		InfoRect {
			id: infoItem;

			width: game.width;
			height: game.height;

			anchors.left: game.right;
			anchors.leftMargin: 100;

			gameScore: game.gameScore;
			currentLevel: game.currentLevel;
		}

		Rectangle{
			id: menuScreen;

			width: safeArea.width;
			height: safeArea.height;

			color: colorTheme.globalBackgroundColor;
			opacity: 0.7;

			visible: (exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
		}

		onUpPressed: { pauseMenu.show(); }

		onMenuPressed: { exitMenu.show(); }

		onBackPressed: { exitMenu.show(); }

		onLastPressed: { exitMenu.show(); }

		function exitGame() {
			game.setNewGame();
			viewsFinder.closeApp();
		}

		function updateInfo(info) {
			game.gameScore = info.score;
			game.currentLevel = info.level;
		}

		function setNewGame() {
			exitMenu.visible = false;
			gameOverMenu.visible = false;
			pauseMenu.visible = false;

			levelMenu.show();

			var info = engine.restartGame(gameView.model, blockView.model, nextBlockView.model);
			game.updateInfo(info);
			game.setStartCoordinates();
		}

		function nextStep() {
			engine.nextStep(blockView.model, nextBlockView.model);

			if (!engine.hasColllisions(game.startX, engine.getPieceOffsetY()))
			{
				game.setStartCoordinates();
			}
			else
			{
				gameOverMenu.show();
			}
		}

		function setStartCoordinates() {
			movingTetraminos.x = game.startX;
			movingTetraminos.y = engine.getPieceOffsetY();
			engine.updateProperties(movingTetraminos.x, movingTetraminos.y, blockView.model);
		}
	}

	Item {
		ExitMenu {
			id: exitMenu;

			width: game.width;
			height: 225;

			anchors.centerIn: game;

			onUpPressed: { }

			onBackToGame: {
				exitMenu.visible = false;
				movingTetraminos.setFocus();
			}

			onSetNewGame: {
				exitMenu.visible = false;
				game.setNewGame();
			}

			onExitGame: {
				exitMenu.visible = false;
				game.exitGame();
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: 225;

			anchors.centerIn: game;

			onSetNewGame: {
				gameOverMenu.visible = false;
				game.setNewGame();
			}

			onExitGame: {
				gameOverMenu.visible = false;
				game.exitGame();
			}
		}

		LevelMenu {
			id: levelMenu;

			width: game.width;
			height: 118;

			anchors.centerIn: game;

			onLevelChanged: {
				levelMenu.visible = false;
				game.currentLevel = level;
				engine.setCurrentLevel(game.currentLevel);
				movingTetraminos.setFocus();

				game.nextStep();
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: 73;

			anchors.centerIn: game;

			onContinueGame: {
				pauseMenu.visible = false;
				movingTetraminos.setFocus();
			}
		}

		onUpPressed: { }

		onKeyPressed: {
			if (key == "Menu" || key == "Back" || key == "Last")
			{
				game.setNewGame();

				return false;
			}
		}
	}

	onKeyPressed: {
		if (key == "Power Off")
		{
			game.setNewGame();

			return false;
		}
	}

	onCompleted: {
		levelMenu.show();
		engine.initGame(gameView.model, blockView.model, nextBlockView.model);
		game.setStartCoordinates()
	}


}
