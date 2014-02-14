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
//			anchors.topMargin: 50;
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
				anchors.top: parent.top;
				onBackPressed: {
					pageStack.currentIndex = 0;
					gameMenu.setFocus();
				}
			}
		}

	    Resource {
		        id: playersResource;
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
