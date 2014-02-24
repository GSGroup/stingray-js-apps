import controls.Text;
import controls.PageStack;
import GameMenu;
import Game;
import GameStats;

Application {
	    id: sudokuApplication;
	    focus: true;
	    name: "sudoku";
	    displayName: qsTr("Sudoku");

	    MainText {
		        id: titleText;
		        anchors.top: parent.top;
		        anchors.horizontalCenter: parent.horizontalCenter;
		        text: "sudoku";
        }
		
		PageStack {
			id: pageStack;

            anchors.top: titleText.bottom;

			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.topMargin: 10;
			anchors.leftMargin: control.width + control.anchors.leftMargin;
			anchors.rightMargin: control.width + control.anchors.leftMargin;
			anchors.horizontalCenter: parent.horizontalCenter;
	
	        GameMenu {
	        	id: gameMenu;
				anchors.fill: parent;
				visible: parent.visible;
				
                onNewGameEvent: {
                    log("onNewGameEvent player = "+player+" difficulty "+difficulty);
					pageStack.currentIndex = 1;
                    game.gameReset();
                    game.difficulty = difficulty;
                    game.player = player;
                    log("GAME.PLAYER "+game.player+ " PLAYER "+player);
					game.setFocus();

                }

				onPlayEvent: {
					log("onPlayEvent player "+player+ " diff "+difficulty);
                    if(game.isIncomplete){
					    pageStack.currentIndex = 1;

		                game.timeIndicator.timer.start();

					    game.setFocus();
                    }
				}

				onHelpEvent: {
					log("onHelpEvent");
				}
        	}

			Game {
				id: game;
				height: parent.width/1.5;
				width: parent.width/1.5;
				anchors.left: control.img.right;
				anchors.leftMargin: 50;
				anchors.top: parent.top;
                isIncomplete: false;

				onBackPressed: {
					pageStack.currentIndex = 2;
					this.timeIndicator.timer.stop();
					this.digitChooser.visible=false;
					gameSubMenu.setFocus();
					gameSubMenu.gameInfoText.text=game.timeIndicator.text;

				}
				
				onKeyPressed:
				{
					if(key=="A")
					{
						this.gameOverEvent("test");
					}
				}

				onGameOverEvent: {
//					log("GAME OVER EVENT "+result);
//                    log("befor reset player "+this.player+ " time "+this.timeIndicator.sec);
                    gameStats.addNrestat({player: this.player, time: this.timeIndicator.sec});
				    this.gameReset();
                    this.isIncomplete = false;
                    gameMenu.playButton.enabled = false;
					gameOverBox.subText.text=result;
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
				}

			}

			 Item {
				id: gameOverBox;
				anchors.verticalCenter: parent.anchors.verticalCenter;
				anchors.horizontalCenter: parent.anchors.horizontalCenter;
				height:150;
				width:350;
				focus: true;

				BigText {
					id: subText;
					anchors.topMargin:20;
					anchors.verticalCenter: gameOverBox.anchors.verticalCenter;
					anchors.horizontalCenter: gameOverBox.anchors.horizontalCenter;
					text:"";
				}
                     
				onBackPressed: {
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
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
        
	    SmallText {
		        id: control;
		        anchors.verticalCenter: parent.verticalCenter;
		        anchors.left: parent.left;
		        anchors.leftMargin: 70;
		        color: "#7c83ad";
		        text: "Control";

		        Image {
						id:img;
			            anchors.top: parent.top;
			            anchors.left: parent.left;
			            source: "apps/sudoku/img/control.png";
			            visible: parent.visible;
		        }
	    }
        
        GameStats {
            id: gameStats;
            anchors.top: gameMenu.difficultyChooser.bottom;
            anchors.right: parent.right;
            anchors.rightMargin: 145;
        }

}
