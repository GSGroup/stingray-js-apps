import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "PauseRect.qml";
import "ItemDelegate.qml";

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
		property int currentLevel: 1;
		property int startX: gameConsts.getGameWidth() / 2 - gameConsts.getBlockSize() * 2;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainScreen;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		GridView {
			id: gameView;

			width: game.width;
			height: game.height;

			cellWidth: gameConsts.getBlockSize();
			cellHeight: gameConsts.getBlockSize();
			orientation: Vertical;

			model: ListModel {
				property int value;
				property int colorIndex;
				property string backColor;
			}
			delegate: ItemDelegate { }
		}

		Item {
			id: movingTetraminos;

			x: game.startX;
			y: 0;

			width: gameConsts.getBlockSize() * 4;
			height: gameConsts.getBlockSize() * 4;

			GridView {
				id: blockView;

				width: gameConsts.getBlockSize() * 4;
				height: gameConsts.getBlockSize() * 4;

				orientation: Vertical;
				cellWidth: gameConsts.getBlockSize();
				cellHeight: gameConsts.getBlockSize();

				model: ListModel {
					property int value;
					property int colorIndex;
					property string backColor;
				}
				delegate: ItemDelegate { }
			}

			onUpPressed:{
				if (engine.tryRotate())
				{
					engine.rotate();
					engine.updateBlockView(blockView.model);
				}
			}

			onKeyPressed: {
				var directionX = 0;
				var directionY = 0;

				switch (key)
				{
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
					default: return false;
				}

				var stepX = directionX * game.stepSize;
				var stepY = directionY * game.stepSize;
				if (!engine.hasColllisions(movingTetraminos.x + stepX, movingTetraminos.y + stepY))
				{
					movingTetraminos.x += stepX;
					movingTetraminos.y += stepY;
					return true;
				}
			}
		}

		Timer {
			id: animTimer;

			interval: engine.getDropTime() / (gameConsts.getGlassHeight() - 4) / game.currentLevel;
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!engine.hasColllisions(movingTetraminos.x, movingTetraminos.y + game.stepSize))
				{
					movingTetraminos.y += game.stepSize;
				}
				else
				{
					engine.nextStep(blockView.model, nextBlockView.model);
					movingTetraminos.x = game.startX;
					movingTetraminos.y = 0;
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

				GridView {
					id: nextBlockView;

					x: gameConsts.getBlockSize();
					y: gameConsts.getBlockSize();

					width: gameConsts.getBlockSize() * 4;
					height: gameConsts.getBlockSize() * 4;

					orientation: Vertical;
					cellWidth: gameConsts.getBlockSize();
					cellHeight: gameConsts.getBlockSize();

					model: ListModel {
						property int value;
						property int colorIndex;
						property string backColor;
					}
					delegate: ItemDelegate { }
				}
			}

			SmallCaptionText {
				id: levelText;

				anchors.top: nextTetraminos.bottom;
				anchors.leftMargin: gameConsts.getBlockSize();

				text: qsTr("Уровень");
				color: colorTheme.highlightPanelColor;
			}

			SmallCaptionText {
				id: scoreRect;

				anchors.top: levelText.bottom;
				anchors.topMargin: gameConsts.getBlockSize();
				anchors.leftMargin: gameConsts.getBlockSize();

				text: qsTr("Счет");
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
				movingTetraminos.setFocus();
				engine.restartGame();
			}

			onKeyPressed: {
				if (key === "8" || key === "7" || key === "6")
				{
					return true;
				}
			}
		}

		GameOverMenu {
			id: gameOverMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 4;

			anchors.centerIn: game;

			onBackToGame: {
				gameOverMenu.visible = false;
				movingTetraminos.setFocus();
			}

			onKeyPressed: {
				if (key === "8" || key === "7")
				{
					return true;
				}
			}
		}

		LevelMenu {
			id: levelMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 3;

			anchors.centerIn: game;

			onBackToGame: {
				levelMenu.visible = false;
				movingTetraminos.setFocus();
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 6 + game.space * 4;

			anchors.centerIn: game;
		}

		onSelectPressed: {
			exitMenu.show();
			return true;
		}

		on8Pressed: {
			pauseMenu.show();
			return true;;
		}

		on7Pressed: {
			levelMenu.show();
			return true;
		}

		on6Pressed: {
		{
			gameOverMenu.show();
			return true;
		}

		onCompleted: { engine.initGame(gameView.model, blockView.model, nextBlockView.model); }
	}
}
