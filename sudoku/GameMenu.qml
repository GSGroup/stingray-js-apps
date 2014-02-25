import controls.Button;
import EditPlayerNamePanel;
import Chooser;

GameMenu : Item {
        id: mainMenu;
		focus: true;

        event newGameEvent(difficulty, player);
		event playEvent(difficulty,player);
		event helpEvent();

        PlayerChooser {
                id: playerChooser;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;

				onDownPressed: {
					difficultyChooser.setFocus();
				
				}
                
                onSelectPressed: {
                        pNameEdit.show();
                }
        }

        DifficultyChooser {
                id: difficultyChooser;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: playerChooser.bottom ; 
                
				onUpPressed: {
					playerChooser.setFocus();
				}

				onDownPressed: {
					newGameButton.setFocus();
				}
        }

		Button {
			id: newGameButton;
			anchors.top: difficultyChooser.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;
			font: bigFont;
			text: "New Game";
			
			onUpPressed: {
				difficultyChooser.setFocus();
			}

			onDownPressed: {
				playButton.enabled?playButton.setFocus():helpButton.setFocus();
			}
			
			onSelectPressed: {
				log("newGameButton PRESSED!");
				parent.newGameEvent(mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).text,
                    mainMenu.playerChooser.listView.model.get(playerChooser.currentIndex).player);
			}
		}

		Button {
			id: playButton;
			anchors.top: newGameButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;
			font: bigFont;
			text: "Play";
            enabled: false;
			
			onUpPressed: {
				newGameButton.setFocus();
			}

			onDownPressed: {
				helpButton.setFocus();
			}
			
			onSelectPressed: {
				log("playButton PRESSED!");
				parent.playEvent(mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).text,
                    mainMenu.playerChooser.listView.model.get(playerChooser.currentIndex).text);
			}
		}


		Button {
			id: helpButton;
			anchors.top: playButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 250;
			height: 50;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			font: bigFont;
			text: "Help";
			
			onUpPressed: {
                playButton.enabled?playButton.setFocus():newGameButton.setFocus();
			}

			onDownPressed: {
			}
			
			onSelectPressed: {
				log("helpButton PRESSED!");
				parent.helpEvent();
			
			}
		}

        EditPlayerNamePanel {
                id: pNameEdit;
                anchors.top: playerChooser.bottom;
                anchors.horizontalCenter: parent.horizontalCenter;
                opacity: 0.01;

                onAccepted: {
                        log("set player name");
                        mainMenu.playerChooser.listView.model.setProperty(mainMenu.playerChooser.currentIndex,'player',text);
                        this.opacity = 0.01;
                        mainMenu.playerChooser.setFocus();
                }

        }


        function load(data)
        {
                log("loading players..");
                this.players = data ["stats"];
                for (var i = 0; i < this.players.length; ++i){
                        mainMenu.playerChooser.append(this.players[i]);
                }

                log("loading difficulty levels..");
				this.difflevels = data ["difflevels"];
				for (var  i= 0; i< this.difflevels.length; ++i ){
					    mainMenu.difficultyChooser.append(this.difflevels[i]);
				}
        }
}


GameSubMenu : Item {
	    id: subMenu;
		focus: true;

		event continueEvent();
		event menuCallEvent();

		BigText {
			id: playerInfoText;
			anchors.topMargin: 40;
			anchors.horizontalCenter: parent.horizontalCenter;
			text: "";
		}

		BigText {
			id: gameInfoText;
			anchors.top: playerInfoText.bottom;
			anchors.topMargin: 40;
			anchors.horizontalCenter: parent.horizontalCenter;
		 
		}

		Button {
			id: continueButton;
			anchors.top: gameInfoText.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;
			font: bigFont;
			text: "continue";
			
			onUpPressed: {
			}

			onDownPressed: {
				menuCallButton.setFocus();
			}
			
			onSelectPressed: {
				log("CONTINUE PRESSED!");
				parent.continueEvent();
			}
		}


		Button {
			id: menuCallButton;
			anchors.top: continueButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 250;
			height: 50;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			font: bigFont;
			text: "to main menu";
			
			onUpPressed: {
				continueButton.setFocus();
			}

			onDownPressed: {
			}
			
			onSelectPressed: {
				log("helpButton PRESSED!");
				parent.menuCallEvent();
			
			}
		}
}
