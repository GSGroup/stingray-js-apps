import "engine.js" as engine;
import "BoardModel.qml";
import "CellDelegate.qml";

Rectangle {
	id: game;

	anchors.fill: parent;

	difficultyLevel: 0;
	playerWhite: true;
	over: false;
	whiteCounter: 2;
	blackCounter: 2;
	
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
		width: childrenWidth;
		height: childrenHeight;

		anchors.right: boardRect.right;
		anchors.bottom: boardRect.top;

		spacing: 10;

		MainText {
			text: "Black";
		}

		MainText {
			id: blackText;
			text: "2";
		}
	}

	BigText {
		id: gameOver;

		anchors.centerIn: boardRect;

		focus: true;
		z: 1;
		style: Shadow;
		styleColor: "#333";

		visible: false;

		Rectangle {
			anchors.fill: parent;
			anchors.margins: -20;

			color: "#000c";
		}
	}

	Rectangle {
		id: boardRect;

		width: 65 * 8;
		height: 65 * 8;

		anchors.centerIn: parent;
		
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
					{
						gameOver.text = game.playerWhite ? "You won!" : "Game Over";
					}
					else
					{
						gameOver.text = !game.playerWhite ? "You won!" : "Game Over";
					}
					game.over = true;
					gameOver.visible = true;
				}
				else
				{
					this.restart(); //one more time
				}
			}
		}
	}

	Rectangle {
		height: 64;

		anchors.top: boardRect.bottom;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;

		Rectangle {
			id: red;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: parent.left;

			SmallText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: "Help";
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2;
				color: "#ff0000";
			}
		}

		Rectangle {
			id: green;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: red.right;

			SmallText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: "Start with white";
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2;
				color: "#00ff00";
			}
		}

		Rectangle {
			id: yellow;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: green.right;

			SmallText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: "Start with black";
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2;
				color: "#ffff00";
			}
		}

		Rectangle {
			id: blue;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: yellow.right;

			SmallText {
				id: difftext;

				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: "Easy";
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2;
				color: "#0000ff";
			}
		}
	}

	onBackPressed: { viewsFinder.closeApp(); }

	onKeyPressed: {
			switch (key)
			{
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
					if (game.difficultyLevel == 0)
					{
						game.difficultyLevel = 10;
						difftext.text = "Hard";
					}
					else if (game.difficultyLevel == 1)
					{
						game.difficultyLevel = -10;
						difftext.text = "Easy";
					}
					break;
			}

			if (game.over)
			{
				engine.Reset();
				game.update();
				gameOver.visible = false;
				game.over = false;
				return true;
			}

			log("key: " +  key);
			if (key == "Select")
			{
				if (game.difficultyLevel == 10)
				{
					game.difficultyLevel = 1;
				}
				else if (game.difficultyLevel == -10)
				{
					game.difficultyLevel = 0;
				}

				if (aiMoveTimer.running) //ai is "thinking"
					return true;

				log("player moves into " + Math.floor(gameView.currentIndex / 8) + ", " + gameView.currentIndex % 8);
				if (engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false) <= 0)
					return true;

				engine.WriteModel();
				game.update();
				aiMoveTimer.start();

				return true;
			}
		return false;
	}

	function update() {
		game.whiteCounter = 0;
		game.blackCounter = 0;

		for (var i = 0; i < gameView.model.count; i++)
		{
			switch (gameView.model.get(i).disc)
			{
				case 'White':
					game.whiteCounter++;
					break;
				case 'Black':
					game.blackCounter++;
					break;
			}
		}

		whiteText.text = game.whiteCounter;
		blackText.text = game.blackCounter;
	}
}
