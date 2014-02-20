import controls.SimpleChooser;
import controls.Button;

GameMenu : Item {
        id: mainMenu;
		focus: true;

		event playEvent();
		event helpEvent();
        SimpleChooser {
                id: difficultyChooser;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: playerChooser.bottom ; 

				onUpPressed: {
					playerChooser.setFocus();
				}
				onDownPressed: {
					playButton.setFocus();
				}
        }

        SimpleChooser {
                id: playerChooser;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;

				onDownPressed: {
					difficultyChooser.setFocus();
				
				}
        }

		Button {
			id: playButton;
			anchors.top: difficultyChooser.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;
			font: bigFont;
			text: "Play";
			
			onUpPressed: {
				difficultyChooser.setFocus();
			}

			onDownPressed: {
				helpButton.setFocus();
			}
			
			onSelectPressed: {
				log("playButton PRESSED!");
				parent.playEvent();
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
				playButton.setFocus();
			}

			onDownPressed: {
			}
			
			onSelectPressed: {
				log("helpButton PRESSED!");
				parent.helpEvent();
			
			}
		}



        function load(data)
        {
                log("loading players..");
                this.players = data ["players"];
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
			text: "player"+""
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
