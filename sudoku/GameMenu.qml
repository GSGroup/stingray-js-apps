import controls.Button;
import controls.FocusablePanel;
import EditPlayerNamePanel;
import Chooser;

GameMenu : Item {
        id: mainMenu;
		focus: true;

        event newGameEvent(difficulty, player,diffInt);
		event playEvent(difficulty,player);
		event difficultySet(difficulty);
		event helpEvent();
		event enablePlayBtnEvent(player,diffInt);

		Image {
			 id: mainMenuTheme;
			 anchors.horizontalCenter: safeArea.horizontalCenter;
			 anchors.verticalCenter: safeArea.verticalCenter;
			 source: "apps/sudoku/img/ground_main.png";

		}

        PlayerChooser {
                id: playerChooser;
//                anchors.left: parent.left;
				width: 400;
//				anchors.horizontalCenter: parent.horizontalCenter;
                anchors.left: parent.left;
				anchors.leftMargin: 55;
                anchors.top: parent.top;

				onDownPressed: {
					difficultyChooser.setFocus();
				
				}
                
                onSelectPressed: {
                    pNameEdit.show();
                }

				onCurrentIndexChanged: {
					parent.enablePlayBtnEvent(playerChooser.listView.model.get(playerChooser.listView.currentIndex).player,
						difficultyChooser.listView.model.get(difficultyChooser.listView.currentIndex).factor);
				}
        }

        DifficultyChooser {
                id: difficultyChooser;

                anchors.top: playerChooser.bottom ; 
				anchors.topMargin: 15;
                anchors.left: parent.left;
			   	anchors.leftMargin: 55;
				width: 400;


                
				onUpPressed: {
					playerChooser.setFocus();
				}

				onDownPressed: {
					newGameButton.setFocus();
				}

				onCurrentIndexChanged: {
					parent.difficultySet(this.listView.currentIndex+1);
					parent.enablePlayBtnEvent(playerChooser.listView.model.get(playerChooser.listView.currentIndex).player,
						difficultyChooser.listView.model.get(difficultyChooser.listView.currentIndex).factor);
				}
        }

		FocusablePanel {
			id: newGameButton;
			anchors.top: difficultyChooser.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 15;
//			anchors.bottomMargin: 10;
			width: 250;
			height: 50;
			font: bigFont;

			borderColor: "#00000000";
			borderWidth: 0;
			radius: 0;
			color: "#00000000";

			Image {
				id:dcDelegateImgage;
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
			}

			SmallText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: "#581B18";
				text:"New Game";
			}
			
			onUpPressed: {
				difficultyChooser.setFocus();
			}

			onDownPressed: {
				playButton.enabled?playButton.setFocus():helpButton.setFocus();
			}
			
			onSelectPressed: {
				log("newGameButton PRESSED!");
				parent.newGameEvent(mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).name,
                    mainMenu.playerChooser.listView.model.get(playerChooser.currentIndex).player,
					mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).factor);
			}
		}

		FocusablePanel {
			id: playButton;
			anchors.top: newGameButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 5;

			width: 250;
			height: 50;
            enabled: false;
			borderColor: "#00000000";
			borderWidth: 0;
			radius: 0;
			color: "#00000000";


			Image {
				id:dcDelegateImgage;
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
			}

			SmallText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: "#581B18";
				text:"Play";
			}

			
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


		FocusablePanel {
			id: helpButton;
			anchors.top: playButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 250;
			height: 50;
			anchors.topMargin: 5;

			font: bigFont;
			text: "Help";
			borderColor: "#00000000";
			borderWidth: 0;
			radius: 0;
			color: "#00000000";
			

			Image {
				id:dcDelegateImgage;
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
			}


			SmallText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: "#581B18";
				text:"Help";
			}

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
//                this.players = data ["players"];
				this.players = load("sudokuPlayers");
                for (var i = 0; i < this.players.length; ++i){
                        mainMenu.playerChooser.append(this.players[i]);
                }

                log("loading difficulty levels..");
				this.difflevels = data ["difflevels"];
				for (var  i= 0; i< this.difflevels.length; ++i ){
					    mainMenu.difficultyChooser.append(this.difflevels[i]);
				}
        }

		function reFillPlayerChooser(data){
				 mainMenu.playerChooser.listView.model.reset();
				 for(var i =0; i<data.count; ++i){
				 		 mainMenu.playerChooser.append({player: data.get(i)['player']});
				 }
		}

		function savePlayers()
		{
			var players =[];
			for(var i =0 ;i<mainMenu.playerChooser.listView.model.count;++i){
				players.push(mainMenu.playerChooser.listView.model.get(i));
			}
			log("plaerys "+players);
			save("sudokuPlayers",players);
		}
}


GameSubMenu : Item {
	    id: subMenu;
		focus: true;

		event continueEvent();
		event menuCallEvent();

		Image {
			 id: subMenuTheme;
			 anchors.horizontalCenter: safeArea.horizontalCenter;
			 anchors.verticalCenter: safeArea.verticalCenter;
			 source: "apps/sudoku/img/ground_pause.png";
		}

		BigText {
			id: playerInfoText;
			anchors.top: subMenuTheme.top;
			anchors.topMargin: 140;
			anchors.horizontalCenter: parent.horizontalCenter;
			text: "";
		}

		BigText {
			id: gameInfoText;
			anchors.top: playerInfoText.bottom;
			anchors.topMargin: 20;
			anchors.horizontalCenter: parent.horizontalCenter;
		 
		}

		FocusablePanel {
			id: continueButton;
			anchors.top: gameInfoText.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;

			borderColor: "#00000000";
			borderWidth: 0;
			radius: 0;
			color: "#00000000";

			Image {
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
			}

			SmallText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
				text:"continue";
			}

			
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

		FocusablePanel {
			id: menuCallButton;
			anchors.top: continueButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 250;
			height: 50;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;

			borderColor: "#00000000";
			borderWidth: 0;
			radius: 0;
			color: "#00000000";

			Image {
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
			}

			SmallText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
				text:"to main menu";
			}
			
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

GameOverBox : Item {
	id: gameOverBox;

	event continueEvent();
	event menuCallEvent();


	anchors.verticalCenter: parent.anchors.verticalCenter;
	anchors.horizontalCenter: parent.anchors.horizontalCenter;
	height:150;
	width:350;

	focus: true;
	
	Image {
		id: finalTheme;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		source: "apps/sudoku/img/ground_final.png";
	}
 
	BigText {
		id: resText;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;	
		anchors.bottomMargin:180;
		
		text:"";
	}


	BigText {
		id: difficulty;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.top: finalTheme.top;	
		anchors.topMargin:60;
		
		text:"";
	}

	BigText {
		id: player;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.top: finalTheme.top;	
		anchors.topMargin:100;
		
		text:"";
	}
	
	BigText {
		id: time;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;	
		anchors.bottomMargin:120;
		
		text:"";
	}

	FocusablePanel {
		id: continueButton;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;
		anchors.bottomMargin: 70;
		width: 250;
		height: 50;

		borderColor: "#00000000";
		borderWidth: 0;
		radius: 0;
		color: "#00000000";

		Image {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
			source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
		}

		SmallText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
			text:"continue";
		}

			
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


	FocusablePanel {
		id: menuCallButton;
		anchors.top: continueButton.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		width: 250;
		height: 50;
		anchors.topMargin: 5;


		borderColor: "#00000000";
		borderWidth: 0;
		radius: 0;
		color: "#00000000";

		Image {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
 			source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
		}

		SmallText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
			text:"to main menu";
		}
			
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

                    
	onBackPressed: {
		pageStack.currentIndex = 0;
		gameMenu.setFocus();
		gameStats.opacity=1;
	}

			
}