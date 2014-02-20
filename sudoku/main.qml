import controls.Text;
import controls.PageStack;
import GameMenu;
import Game;

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
		
		PageStack{
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
				
				onPlayEvent: {
					log("onPlayEvent");
					pageStack.currentIndex = 1;
					if(game.timeIndicator.text!="0:0"){
						game.timeIndicator.timer.restart();}
//					game.gameView.model.reset();
//					game.gameView.fillModel();
					game.setFocus();
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

				onBackPressed: {
					pageStack.currentIndex = 2;
					game.timeIndicator.timer.stop();
					game.digitChooser.visible=false;
					gameSubMenu.setFocus();
					gameSubMenu.gameInfoText.text=game.timeIndicator.text;

				}
				
				onKeyPressed:
				{
					if(key=="A")
					{
						game.gameOverEvent("test");
					}
				}

				onGameOverEvent: {
					this.timeIndicator.timer.restart();
					this.timeIndicator.timer.stop();
					this.timeIndicator.text="0:0"
					log("GAME OVER EVENT "+result);
					gameOverBox.subText.text=result;
					pageStack.currentIndex = 3;
					log("model count befor reset "+game.gameView.model.count)
					game.gameView.model.reset();
					game.gameView.fillModel();
					log("model count after reset "+game.gameView.model.count)
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
					game.timeIndicator.timer.start();

				}

				onMenuCallEvent: {
					log("MENUCALL EVENT DETECTED");
					pageStack.currentIndex = 0;
					gameMenu.setFocus();

				}

				/*onBackPressed: {
					pageStack.currentIndex = 1;
					game.setFocus();
				}*/
			}

			 Item{
				id: gameOverBox;
				anchors.verticalCenter: parent.anchors.verticalCenter;
				anchors.horizontalCenter: parent.anchors.horizontalCenter;
				height:150;
				width:350;
				focus: true;
				BigText{
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
}
