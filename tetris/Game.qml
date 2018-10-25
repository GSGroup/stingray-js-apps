import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "PauseRect.qml";
import "MenuItem.qml";

import "LevelDelegate.qml";
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
		property int startX: gameConsts.getGameWidth() / 2 - gameConsts.getBlockSize() * 2;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainWindow;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		GridView {
			id: gameView;

			width: game.width;
			height: game.height;

			cellWidth: gameConsts.getBlockSize();
			cellHeight: gameConsts.getBlockSize();
			orientation: GridView.Vertical;

			ListModel {
				id: gameCanvasModel;

				property int value;
				property int colorIndex;
				property string backColor;
			}

			model: gameCanvasModel;
			delegate: ItemDelegate { }
		}

		Item {
			id: movingTetraminos;

			x: game.startX;
			y: 0;

			GridView {
				id: blockView;

				width: gameConsts.getBlockSize() * 4;
				height: gameConsts.getBlockSize() * 4;

				orientation: Vertical;
				cellWidth: gameConsts.getBlockSize();
				cellHeight: gameConsts.getBlockSize();

				ListModel {
					id: movingBlockModel;

					property int value;
					property int colorIndex;
					property string backColor;
				}

				model: movingBlockModel;
				delegate: ItemDelegate { }
			}

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
					if (engine.tryRotate()) {
						engine.rotate();
						engine.updateBlockView(blockView.model);
					}
					return true;
				default: return false;
				}

				if (!engine.checkColllisions(movingTetraminos.x + directionX * game.stepSize, movingTetraminos.y + directionY * game.stepSize)) {
					movingTetraminos.x += directionY * game.stepSize;
					movingTetraminos.y += directionX * game.stepSize;
					return true;
				}
			}
		}

		Timer {
			id: animTimer;

			interval: engine.getTimerInterval();
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!engine.checkColllisions(movingTetraminos.x, movingTetraminos.y + game.stepSize)) {
					movingTetraminos.y += game.stepSize;
				}
				else {
					engine.nextStep(blockView.model, nextBlockView.model);

					movingTetraminos.x = game.startX;
					movingTetraminos.y = 0;

					animTimer.restart();
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

					ListModel {
						id: nextBlockModel;

						property int value;
						property int colorIndex;
						property string backColor;
					}

					model: nextBlockModel;
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
				animTimer.restart();
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
			height: gameConsts.getBlockSize() * 3;

			anchors.centerIn: game;

			onVisibleChanged: {
				movingTetraminos.setFocus();
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: gameConsts.getBlockSize() * 6 + game.space * 4;

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

		onCompleted: {
			engine.initGame(gameView.model, blockView.model, nextBlockView.model);
		}
	}
}
