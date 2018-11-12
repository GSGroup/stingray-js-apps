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
		property bool deletingLines: false;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainScreen;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		ItemGridView {
			id: gameView;

			animationTime: animTimer.interval;

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

				visible: !game.deletingLines;
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
				// удаляем ряд если есть флаг
				if (game.deletingLines)
				{
					game.updateInfo(engine.removeLines(gameView.model));

					// проверяем нужно ли удалять еще раз
					if ( engine.checkLines() > 0)
					{
						engine.updateModelWidth(gameView.model);
					}
					else
					{
						game.deletingLines = false;
						game.nextStep();
					}
				}
				// если нет удаления работаем в обычном режиме
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

						if( engine.checkLines() > 0 )
						{
							engine.updateModelWidth(gameView.model);
							game.deletingLines = true;
						}
						else
						{
							game.nextStep();
						}
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

				text: tr("Уровень ") + game.currentLevel;
				color: colorTheme.highlightPanelColor;
			}

			SmallCaptionText {
				id: scoreRect;

				anchors.top: levelRect.bottom;
				anchors.topMargin: gameConsts.getBlockSize();
				anchors.leftMargin: gameConsts.getBlockSize();

				text: tr("Счет    ") + game.gameScore;
				color: colorTheme.highlightPanelColor;
			}
		}

		Rectangle{
			id: menuScreen;

			width: safeArea.width;
			height: safeArea.height;

			color: colorTheme.globalBackgroundColor;
			opacity: 0.5;

			visible: (exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
		}

		ExitMenu {
			id: exitMenu;

			width: game.width;
			height: 132;

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
				game.setNewGame();
				viewsFinder.closeApp();
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 4;

			anchors.centerIn: game;

			onKeyPressed: {
				if (key == "Up" || key == "Menu" || key == "Back" || key == "Last")
				{
					return true;
				}
			}

			onSetNewGame: {
				gameOverMenu.visible = false;
				game.setNewGame();
			}

			onExitGame: {
				gameOverMenu.visible = false;
				game.setNewGame();
				viewsFinder.closeApp();
			}
		}

		LevelMenu {
			id: levelMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 3;

			anchors.centerIn: game;

			onKeyPressed: {
				if (key == "Up" || key == "Menu" || key == "Back" || key == "Last")
				{
					return true;
				}
			}

			onLevelChanged: {
				levelMenu.visible = false;
				game.currentLevel = level;
				engine.setCurrentLevel(game.currentLevel);
				movingTetraminos.setFocus();
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 2;

			anchors.centerIn: game;

			onKeyPressed: {
				if (key == "Menu" || key == "Back" || key == "Last")
				{
					return true;
				}
			}

			onContinueGame: {
				pauseRect.visible = false;
				movingTetraminos.setFocus();
			}
		}

		function updateInfo(info) {
			game.gameScore = info.score;
			game.currentLevel = info.level;
		}

		function setNewGame() {
			levelMenu.show();

			movingTetraminos.visible = true;
			movingTetraminos.x = game.startX;
			movingTetraminos.y = 0;

			var info = engine.restartGame(gameView.model, blockView.model, nextBlockView.model);
			game.updateInfo(info);
		}

		function nextStep (){
			engine.nextStep(blockView.model, nextBlockView.model);

			if (!engine.hasColllisions(game.startX, 0))
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

		onUpPressed: { pauseMenu.show(); }

		onMenuPressed: { exitMenu.show(); }

		onBackPressed: { exitMenu.show(); }

		onLastPressed: { exitMenu.show(); }

		onCompleted: {
			levelMenu.show();
			engine.initGame(gameView.model, blockView.model, nextBlockView.model);
		}
	}
}
