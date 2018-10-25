import "engine.js" as engine;
import "CellDelegate.qml";
import "MenuDelegate.qml";

Rectangle {
	id: game;

	property bool easy;
	property bool playerWhite;
	property bool multiplayer: true;
	property bool started;

	anchors.fill: parent;

	over: false;
	whiteCounter: 2;
	blackCounter: 2;

	Rectangle {
		id: mainMenu;

		width: 520;
		height: 520;

		anchors.centerIn: parent;

		focus: true;
		color: "#eee4dab0";

		visible: true;

		BigText {
			id: titleText;

			anchors.top: parent.top;
			anchors.topMargin: 20;
			anchors.horizontalCenter: parent.horizontalCenter;

			text: qsTr("Reversi");
			color: "#000";
		}

		ListView {
			id: menuList;
			height: 240;

			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;

			focus: true;

			model: ListModel {
				ListElement { text: "Start playing alone"; }
				ListElement { text: "Start playing together"; }
			}
			delegate: MenuDelegate{}

			onSelectPressed: {
				switch (this.currentIndex) {
				case 0:
					game.multiplayer = false;
					game.startGame();
					break;
				case 1:
					game.multiplayer = true;
					game.startGame();
					break;
				case 2:
					mainMenu.visible = false;
					break;
				}
			}
		}
	}
	
	Row {
		anchors.left: boardRect.left;
		anchors.bottom: boardRect.top;

		spacing: 10;

		visible: !mainMenu.visible;

		MainText {
			text: qsTr("White");
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

		visible: !mainMenu.visible;

		MainText {
			text: qsTr("Black");
		}

		MainText {
			id: blackText;
			text: "2";
		}
	}

	Column {
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: boardRect.left;
		anchors.rightMargin: 20;

		spacing: 10;

		visible: !game.multiplayer && !mainMenu.visible;

		MainText {
			text: qsTr(game.playerWhite ? "You're playing with white" : "You're playing with black");
		}

		MainText {
			text: qsTr(game.easy ? "Low difficulty" : "High difficulty");
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

		visible: !mainMenu.visible;
		
		GridView {
			id: gameView;

			anchors.fill: parent;

			focus: true;
			cellHeight: 65;
			cellWidth: 65;
			orintation: GridView.Horizontal;

			model: ListModel { }
			delegate: CellDelegate { }
		}		
	}

	Timer {
		id: aiMoveTimer;

		interval: 500;

		onTriggered:  {
			engine.NextMove(!game.playerWhite, false, gameView.model); //my move
			game.update();
			
			if (!engine.NextMove(game.playerWhite, true, gameView.model)) //no next move for player
			{
				if (!engine.NextMove(!game.playerWhite, true, gameView.model)) //no next move for ai also, game over
				{
					log ("GAMEOVER");
					var whiteIsWinner = game.whiteCounter > game.blackCounter;					
					if(whiteIsWinner)
					{
						gameOver.text = qsTr(game.playerWhite ? "You won!" : "Game over");
					}
					else
					{
						gameOver.text = qsTr(!game.playerWhite ? "You won!" : "Game over");
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

		visible: !game.multiplayer && !mainMenu.visible;

		Rectangle {
			id: red;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: parent.left;

			SmallText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: qsTr("Help");
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

				text: qsTr("Start with white");
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

				text: qsTr("Start with black");
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

				text: qsTr(game.easy ? "Hard" : "Easy");
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

	onBackPressed: {
		if (mainMenu.visible)
			viewsFinder.closeApp();
		else
			mainMenu.visible = true;

		return true;
	}

	onKeyPressed: {
			if (game.over)
			{
				game.startGame();
				return true;
			}

			switch (key)
			{
				case "Red":
					if (aiMoveTimer.running) //ai is "thinking"
						return;

					engine.NextMove(game.playerWhite, false, gameView.model);
					game.update();
					aiMoveTimer.start();
					break;
				case "Green":
					game.playerWhite = true;
					game.startGame();
					return true;
				case "Yellow":
					game.playerWhite = false;
					game.startGame();
					return true;
				case "Blue":
					game.easy = !game.easy;
					return true;
			}

			log("key: " +  key);
			if (key == "Select")
			{
				if (aiMoveTimer.running) //ai is "thinking"
					return true;

				log("player moves into " + Math.floor(gameView.currentIndex / 8) + ", " + gameView.currentIndex % 8);
				if (engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false) <= 0)
					return true;

				engine.WriteModel(gameView.model);
				game.update();
				aiMoveTimer.start();

				return true;
			}
		return false;
	}

	function startGame() {
		if (!game.started)
		{
			menuList.model.append({ text: "Continue" });
			game.started = true;
		}
		engine.Reset(gameView.model);
		game.update();
		mainMenu.visible = false;
		gameOver.visible = false;
		game.over = false;
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

	onCompleted: { engine.Init(gameView.model); }
}
