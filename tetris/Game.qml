// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "LevelMenu.qml";
import "ExitMenu.qml";
import "GameOverMenu.qml";
import "PauseRect.qml";
import "InfoRect.qml";
import "ItemGridView.qml";
import "generated_files/RectArray.qml";

import "engine.js" as engine;
import "generated_files/tetrisConsts.js" as gameConsts;

Rectangle{
	id: mainScreen;

	property string appName;

	width: safeArea.width;
	height: safeArea.height;

	focus: true;
	color: colorTheme.globalBackgroundColor;

	Rectangle {
		id: game;

		property int currentLevel: 1;
		property int gameScore: 0;
		property bool deletingLines: false;

		width: gameConsts.getGameWidth();
		height: gameConsts.getGameHeight();

		anchors.centerIn: mainScreen;

		color: colorTheme.focusablePanelColor;
		focus: true;
		radius: 5hpw;

		RectArray { }

		Timer {
			id: animTimer;

			interval: gameConsts.getDropTime() / (gameConsts.getGlassHeight() - 4) / game.currentLevel;
			running: !(exitMenu.visible || levelMenu.visible || pauseMenu.visible || gameOverMenu.visible);
			repeat: true;

			onTriggered: {
				if (!game.deletingLines)
				{
					if (engine.tryStep(engine.downDirection))
					{
						engine.doStep(engine.downDirection);
					}
					else
					{
						if (!engine.writeToCanvas())
						{
							gameOverMenu.show();
						}
						else if (engine.checkFullLines())
						{
							engine.setRemoveLinesAnimation();
							game.deletingLines = true;
						}
						else
						{
							engine.setNewBlock(infoItem.nextBlockView.model);
						}
					}
				}
				else
				{
					game.updateInfo(engine.getInfo());

					engine.resetRemoveLinesAnimation();
					engine.removeLines();

					engine.setNewBlock(infoItem.nextBlockView.model);
					engine.setStartCoordinates();

					game.deletingLines = false;
				}
			}
		}

		InfoRect {
			id: infoItem;

			width: game.width;
			height: game.height;

			anchors.left: game.right;
			anchors.leftMargin: 100hpw;

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

		onRightPressed: { this.move(engine.rightDirection); }

		onLeftPressed: { this.move(engine.leftDirection); }

		onDownPressed: { this.move(engine.downDirection); }

		onSelectPressed: {
			if (engine.tryRotation())
			{
				engine.doRotation();
			}
		}

		onMenuPressed: { exitMenu.show(); }

		onBluePressed: {
			if (event.keySource == "kids")
			{
				exitMenu.show();
			}
		}

		onBackPressed: { exitMenu.show(); }

		onLastPressed: { exitMenu.show(); }

		function exitGame() { appManager.closeCurrentApp(); }

		function move(direction) {
			if (engine.tryStep(direction))
			{
				engine.doStep(direction);
			}
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

			var info = engine.restartGame(infoItem.nextBlockView.model);
			game.updateInfo(info);
			engine.setStartCoordinates();
		}
	}

	Item {
		ExitMenu {
			id: exitMenu;

			width: game.width;

			anchors.centerIn: game;

			onBackPressed: { backToGame(); }

			onBackToGame: {
				exitMenu.visible = false;
				game.setFocus();
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

			anchors.centerIn: game;

			onBackPressed: { setNewGame(); }

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

			anchors.centerIn: game;

			onBackPressed: { levelChanged(1); }

			onLevelChanged: {
				levelMenu.visible = false;
				game.currentLevel = level;
				engine.setCurrentLevel(game.currentLevel);
				engine.setNewBlock(infoItem.nextBlockView.model);
				game.setFocus();
			}
		}

		PauseRect {
			id: pauseMenu;

			width: game.width;
			height: 73hph;

			anchors.centerIn: game;

			onBackPressed: { continueGame(); }

			onContinueGame: {
				pauseMenu.visible = false;
				game.setFocus();
			}
		}

		onUpPressed: { }

		onKeyPressed: {
			if (key == "Menu" || key == "Last" || (key == "Blue" && event.keySource == "kids"))
			{
				return appManager.currentAppName == mainScreen.appName;
			}
		}
	}

	onKeyPressed: {
		if (key == "Power Off" && appManager.currentAppName == mainScreen.appName)
		{
			game.setNewGame();

			return false;
		}
	}

	function resetGame() { game.setNewGame(); }

	onCompleted: {
		levelMenu.show();
		engine.initGame(infoItem.nextBlockView.model);
		engine.setStartCoordinates();
	}
}
