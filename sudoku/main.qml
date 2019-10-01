// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Game.qml";
import "GameMenu.qml";
import "GameOverBox.qml";
import "GameStats.qml";
import "GameSubMenu.qml";
import "Help.qml";

Application {
		id: sudokuApplication;
		focus: true;
		name: "sudoku";
		displayName: tr("Sudoku");
		anchors.horizontalCenter: safeArea.horizontalCenter;
		anchors.verticalCenter: safeArea.verticalCenter;		


		 TitleText {
			id: titleText;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: 140;
			color: "#FFFFFF";
			text: "sudoku";
		}

		PageStack {
			id: pageStack;

			anchors.top: titleText.bottom;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 500;
			anchors.topMargin: 40;
	
			GameMenu {
				id: gameMenu;
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
				width: 400;
				
				onNewGameEvent: {
					log("onNewGameEvent player = "+player+" difficulty "+difficulty+" diffInt "+diffInt);
					pageStack.currentIndex = 1;
					gameStats.opacity=0.01;
					game.difficulty = difficulty;
					game.diffInt = diffInt;
					game.player = player;
					game.gameReset();
					log("GAME.DIFFINT "+game.diffInt+ " DIFFINT "+diffInt);
					gameStats.opacity=0.01;
					game.setFocus();
				}

				onPlayEvent: {
					log("onPlayEvent player "+player+ " diff "+difficulty);
					if (game.isIncomplete)
					{
						pageStack.currentIndex = 1;

						if (game.timeIndicator.sec != 0)
							game.timeIndicator.timer.start();
						gameStats.opacity=0.01;
						game.setFocus();
					}
				}

				onHelpEvent: {
					log("onHelpEvent");
					pageStack.currentIndex=4;
					gameStats.opacity = 0.01;
					help.setFocus();
				}

				onDifficultySet: {
					gameStats.filterByDifficulty(difficulty);
				}
				
				onEnablePlayBtnEvent: {
					log("player = "+player+
					" difficulty = "+difficulty+
					" his game?: "+(player==game.player && difficulty==game.difficulty));
 
					this.playButton.enabled=(player==game.player && diffInt==game.diffInt && game.isIncomplete);
				}
			}

			Game {
				id: game;
				height: safeArea.width/1.1;
				width: safeArea.width/1.1;
				anchors.horizontalCenter: parent.horizontalCenter;
				isIncomplete: false;

				onBackPressed: {
					pageStack.currentIndex = 2;
					this.timeIndicator.timer.stop();
					this.gameHide();
					gameSubMenu.setFocus();
					gameSubMenu.playerInfoText.text="player: "+game.player;
					gameSubMenu.gameInfoText.text=game.timeIndicator.text;

				}

				onKeyPressed: 
				{
					if(key=="A")
					{
						this.gameOverEvent("test");
					}
					log("KEY PRESSED")
				}

				onGameOverEvent: {
					if(result) {
						gameStats.addNrestat({player: this.player, 
													  time: this.timeIndicator.sec, 
										  			  difficulty: gameMenu.difficultyChooser.listView.currentIndex+1});
					}
					gameMenu.savePlayers();
					gameOverBox.player.text=this.player;
					gameOverBox.difficulty.text=this.difficulty;
					gameOverBox.time.text=Math.floor(this.timeIndicator.sec/60)+":"+this.timeIndicator.sec%60;

					this.gameReset();
					this.isIncomplete = false;
					gameMenu.playButton.enabled = false;
					pageStack.currentIndex = 3;
					gameOverBox.setFocus();
				
				}
			}

			GameSubMenu {
				id: gameSubMenu;
				focus: true;
				anchors.fill: parent;

				onContinueEvent: {
					log("CONTINUE EVENT DETECTED");
					pageStack.currentIndex = 1;
					game.setFocus();
					if(game.timeIndicator.sec>0) game.timeIndicator.timer.start();

				}

				onMenuCallEvent: {
					log("MENUCALL EVENT DETECTED");
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
					game.isIncomplete = true;
					gameMenu.playButton.enabled = true;
					gameStats.opacity=1;
				}

			}

			 GameOverBox {
				id: gameOverBox;
				anchors.verticalCenter: parent.anchors.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;

				onBackPressed: {
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
					gameStats.opacity=1;
				}
				
				onMenuCallEvent: {
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
					gameStats.opacity=1;
				}

				onContinueEvent: {
					pageStack.currentIndex = 1;
					gameStats.opacity=0.01;
					game.gameReset();
					gameStats.opacity=0.01;
					game.setFocus();
					
				}
			}

			Help {
				id: help;
				anchors.verticalCenter: parent.anchors.verticalCenter;
				anchors.horizontalCenter: parent.anchors.horizontalCenter;

				onBackPressed: {
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
					gameStats.opacity=1;
				}
				
			}
		}

		Resource {
			id: gameResource;
			url: "apps/sudoku/gameData.json";

			onDataChanged: {
				gameMenu.load(JSON.parse(this.data));
				gameStats.load(JSON.parse(this.data));
			}
		}

		GameStats {
			id: gameStats;
			difficulty: gameMenu.difficultyChooser.listView.currentIndex+1;
			anchors.top: pageStack.top;
			anchors.topMargin: 120;
			anchors.left: pageStack.right;
			anchors.leftMargin: 70;
			width: 50;
			opacity: 1;

			Behavior on opacity { animation: Animation { duration: 300;	}}
		}

		startGame: {
			pageStack.currentIndex = 0;
		}

		onVisibleChanged: {
			if (visible) {
				this.startGame();
			}
		}
}
