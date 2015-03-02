import controls.Button
import controls.FocusablePanel
import EditPlayerNamePanel
import PlayerChooser

Item {
        id: mainMenu;
		focus: true;

        signal newGameEvent(difficulty, player,diffInt);
		signal playEvent(difficulty,player);
		signal difficultySet(difficulty);
		signal helpEvent();
		signal enablePlayBtnEvent(player,diffInt);

		Image {
			 id: mainMenuTheme;
			 anchors.horizontalCenter: safeArea.horizontalCenter;
			 anchors.verticalCenter: safeArea.verticalCenter;
			 source: "apps/sudoku/img/ground_main.png";

		}
		
		SmallText {
			id:playerLabel;
			anchors.top: parent.top;
			anchors.topMargin: 12;
			anchors.left: parent.left;
			anchors.leftMargin: 5;
			color: "#581B18";
			text: "PLAYER:";
		}

        PlayerChooser {
                id: playerChooser;
//                anchors.left: parent.left;
				width: 400;
//				anchors.horizontalCenter: parent.horizontalCenter;
                anchors.left: parent.left;
				anchors.leftMargin: 55;
                anchors.top: parent.top;
				anchors.topMargin: -2;
				
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

		SmallText {
			id:levelLabel;
			anchors.horizontalCenter: playerLabel.horizontalCenter;
			anchors.top: playerLabel.bottom;
			anchors.topMargin: 45;
			color: "#581B18";
			text: "LEVEL:";
		}


        DifficultyChooser {
                id: difficultyChooser;

                anchors.top: playerChooser.bottom ; 
				anchors.topMargin: 18;
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

			radius: 0;

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

				if(!(this.players = load("sudokuPlayers")))
				{
						this.players = data ["players"];
				}

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

