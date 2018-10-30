import "engine.js" as engine;
import "CellDelegate.qml";
import "MenuDelegate.qml";

Rectangle {
	id: game;

	property bool easy;
	property bool playerWhite;
	property bool multiplayer: true;
	property bool started;
	property bool over;
	property int whiteCounter: 2;
	property int blackCounter: 2;

	Rectangle {
		id: mainMenu;

		width: 520;
		height: 520;

		anchors.centerIn: parent;

		focus: true;
		color: "#eee4dab0";

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

			width: 390;
			height: 270;

			anchors.centerIn: parent;

			focus: true;

			model: ListModel {
				ListElement { text: "Start playing alone"; }
				ListElement { text: "Start playing together"; }
			}

			delegate: MenuDelegate { width: parent.width; }

			onSelectPressed: {
				switch (this.currentIndex)
				{
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
			text: qsTr("White") + " " + game.whiteCounter;
		}
	}

	Row {
		anchors.right: boardRect.right;
		anchors.bottom: boardRect.top;

		spacing: 10;

		visible: !mainMenu.visible;

		MainText {
			text: qsTr("Black") + " " + game.blackCounter;
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

	MainText {
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: boardRect.left;
		anchors.rightMargin: 20;

		visible: game.multiplayer && !mainMenu.visible;

		text: qsTr(game.playerWhite ? "White is moving" : "Black is moving");
	}

	BigText {
		id: gameOver;

		anchors.centerIn: boardRect;

		focus: true;
		z: 1;
		style: Shadow;
		styleColor: "#333";
		text: game.whiteCounter == game.blackCounter ? qsTr("Game over. Draw.") :
			game.multiplayer ? game.whiteCounter > game.blackCounter ? qsTr("Game over. White won!") : qsTr("Game over. Black won!") :
			game.playerWhite ? game.whiteCounter > game.blackCounter ? qsTr("You won!") : qsTr("Game over.") :
			game.whiteCounter > game.blackCounter ? qsTr("Game over.") : qsTr("You won!");

		visible: game.over;

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
			var weight = engine.NextMove(!game.playerWhite, false, gameView.model); //my move
			game.update(!game.playerWhite, weight);
			
			if (!engine.NextMove(game.playerWhite, true, gameView.model)) //no next move for player
			{
				if (!engine.NextMove(!game.playerWhite, true, gameView.model)) //no next move for ai also, game over
					game.over = true;
				else
					this.restart(); //one more time
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

	onKeyPressed: {
		if (game.over)
		{
			if (key == "Select" || key == "Back")
				game.finishGame();

			return true;
		}

		if (key == "Back")
		{
			if (mainMenu.visible)
				viewsFinder.closeApp();
			else
				mainMenu.visible = true;

			return true;
		}

		if (game.multiplayer)
		{
			if (key != "Select")
				return true;
			var weight = engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false);
			if (weight <= 0)
				return true;

			engine.WriteModel(gameView.model);
			game.update(game.playerWhite, weight);
			game.playerWhite = !game.playerWhite;

			if (!engine.NextMove(game.playerWhite, true, gameView.model)) // no next move for current player
			{
				if (!engine.NextMove(!game.playerWhite, true, gameView.model)) // no next move for other player, too. Game over
					game.over = true;
				else
					game.playerWhite = !game.playerWhite;	//skip move
			}

			return true;
		}

		switch (key)
		{
			case "Red":
				if (aiMoveTimer.running) //ai is "thinking"
					return;

				var weight = engine.NextMove(game.playerWhite, false, gameView.model);
				game.update(game.playerWhite, weight);
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

		if (key == "Select")
		{
			if (aiMoveTimer.running) //ai is "thinking"
				return true;

			log("player moves into " + Math.floor(gameView.currentIndex / 8) + ", " + gameView.currentIndex % 8);
			var weight = engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false);
			if (weight <= 0)
				return true;

			engine.WriteModel(gameView.model);
			game.update(game.playerWhite, weight);
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
		game.whiteCounter = game.blackCounter = 2;
		mainMenu.visible = false;
		game.over = false;
	}

	function finishGame() {
		game.over = false;
		menuList.model.remove(2);
		game.started = false;
		mainMenu.visible = true;
		engine.Reset(gameView.model);
	}

	function update(white, weight) {
		if (!weight)
			return;

		if (white)
		{
			game.whiteCounter += weight + 1;
			game.blackCounter -= weight;
		}
		else
		{
			game.blackCounter += weight + 1;
			game.whiteCounter -= weight;
		}
	}

	onCompleted: { engine.Init(gameView.model); }
}
