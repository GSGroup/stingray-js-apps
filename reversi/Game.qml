import "engine.js" as engine;
import "BoardModel.qml";
import "CellDelegate.qml";

Rectangle {
	id: game;

	anchors.fill: parent;
	difficultyLevel: 0;
	
	BigText {
		id: titleText;
		text: "Reversi";
		anchors.top: parent.top;
		anchors.horizontalCenter: parent.horizontalCenter;
	}
	

	Row {
		anchors.left: boardRect.left;
		anchors.bottom: boardRect.top;
		spacing: 10;

		MainText {
			text: "White";
		}

		MainText {
			id: whiteText;
			text: "2";
		}
	}

	Row {
		anchors.right: boardRect.right;
		anchors.bottom: boardRect.top;
		spacing: 10;

		width: childrenWidth;
		height: childrenHeight;

		MainText {
			id: blackText;
			text: "2";
		}

		MainText {
			text: "Black";
		}
	}

	BigText {
		id: gameOver;
		Rectangle {
			anchors.fill: parent;
			anchors.margins: -20;
			color: "#000c";
		}
		anchors.centerIn: boardRect;
		focus: true;
		visible: false;
		z: 1;
		style: Shadow;
		styleColor: "#333";
	}

	Rectangle {
		id: boardRect;
		anchors.centerIn: parent;
		width: 65*8;
		height: 65*8;
		
		GridView {
			id: gameView;
			anchors.fill: parent;
			focus: true;
			cellHeight: 65;
			cellWidth: 65;
			orintation: GridView.Horizontal;
			model: BoardModel {}
			delegate: CellDelegate {}
		}		
	}
	
	function update() {
		game.whiteCounter = 0;
		game.blackCounter = 0;
		for (var i = 0; i < gameView.model.count; i ++) 
			switch (gameView.model.get(i).disc) {
			case 'White': game.whiteCounter ++; break;
			case 'Black': game.blackCounter ++; break;
			}
		whiteText.text = game.whiteCounter;
		blackText.text = game.blackCounter;
	}

	playerWhite: true;
	over: false;
	whiteCounter: 2;
	blackCounter: 2;

	Timer {
		id: aiMoveTimer;
		interval: 500;
		onTriggered:  {
			engine.NextMove(!game.playerWhite, false); //my move
			game.update();
			
			if (!engine.NextMove(game.playerWhite, true)) //no next move for player
			{
				if (!engine.NextMove(!game.playerWhite, true)) //no next move for ai also, game over
				{
					log ("GAMEOVER");
					var whiteIsWinner = game.whiteCounter > game.blackCounter;					
					if(whiteIsWinner)
						gameOver.text = game.playerWhite ? "You won!" : "Game Over"
					else gameOver.text = !game.playerWhite ? "You won!" : "Game Over";
					game.over = true;
					gameOver.visible = true;
				}
				else
					this.restart(); //one more time
			}
		}
	}
	

	onBackPressed: {
		viewsFinder.closeApp();
	}
	

	onKeyPressed: {
			switch (key) {
			case "Red": 
				if (aiMoveTimer.running) //ai is "thinking"
					return;
				engine.NextMove(game.playerWhite, false);
				game.update();
			    aiMoveTimer.start();
				break;
			case "Green":
				game.over = true;
				game.playerWhite = true;
				break;
			case "Yellow":
				game.over = true;
				game.playerWhite = false;
				break;
			case "Blue":
				if (game.difficultyLevel == 0) {
					game.difficultyLevel = 10;
					difftext.text = "Hard";
					break;
				}
				if (game.difficultyLevel == 1) {
					game.difficultyLevel = -10;
					difftext.text = "Easy";
				}
			}
			if (game.over) {
				engine.Reset();
				game.update();
				gameOver.visible = false;
				game.over = false;
				return true;
			}
			log("key: " +  key);
			if (key == "Select") {
				if (game.difficultyLevel == 10) game.difficultyLevel = 1;
				if (game.difficultyLevel == -10) game.difficultyLevel = 0;
				if (aiMoveTimer.running) //ai is "thinking"
					return true;

				log("player moves into " + Math.floor(gameView.currentIndex / 8) + ", " + gameView.currentIndex % 8)
				if (engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false) <= 0)
					return true;
				game.update();
				aiMoveTimer.start();
				return true;
			}
		return false;
	}


	Rectangle {
		anchors.top: boardRect.bottom;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 64;
		Rectangle {
			id: red;
			anchors.left: parent.left;
			width: parent.width / 4;
			height: parent.height;
			SmallText {
				text: "Help";
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;
			}
			Rectangle {
				anchors.centerIn: parent;
				anchors.bottomMargin: -30;
				height: 5;
				radius: 2;
				width: parent.width / 3;
				color: "#ff0000";
			}
		}
		Rectangle {
			id: green;
			anchors.left: red.right;
			width: parent.width / 4;
			height: parent.height;
			SmallText {
				text: "Start with white";
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;
			}
			Rectangle {
				anchors.centerIn: parent;
				anchors.bottomMargin: -30;
				height: 5;
				radius: 2;
				width: parent.width / 3;
				color: "#00ff00";
			}
		}
		Rectangle {
			id: yellow;
			anchors.left: green.right;
			width: parent.width / 4;
			height: parent.height;
			SmallText {
				text: "Start with black";
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;
			}
			Rectangle {
				anchors.centerIn: parent;
				anchors.bottomMargin: -30;
				height: 5;
				radius: 2;
				width: parent.width / 3;
				color: "#ffff00";
			}
		}
		Rectangle {
			id: blue;
			anchors.left: yellow.right;
			width: parent.width / 4;
			height: parent.height;
			SmallText {
				id: difftext;
				text: "Easy";
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;
			}
			Rectangle {
				anchors.centerIn: parent;
				anchors.bottomMargin: -30;
				height: 5;
				radius: 2;
				width: parent.width / 3;
				color: "#0000ff";
			}
		}
	}
}
