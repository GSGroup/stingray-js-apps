// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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

		width: 520hpw;
		height: 520;

		anchors.centerIn: parent;

		focus: true;
		color: "#eee4dab0";

		TitleText {
			id: titleText;

			anchors.top: parent.top;
			anchors.topMargin: 20;
			anchors.horizontalCenter: parent.horizontalCenter;

			text: tr("Reversi");
			color: "#000";
		}

		ListView {
			id: menuList;

			width: 390hpw;
			height: 270;

			anchors.centerIn: parent;

			uniformDelegateSize: true;

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

		SubheadText {
			text: tr("White") + " " + game.whiteCounter;
		}
	}

	Row {
		anchors.right: boardRect.right;
		anchors.bottom: boardRect.top;

		spacing: 10;

		visible: !mainMenu.visible;

		SubheadText {
			text: tr("Black") + " " + game.blackCounter;
		}
	}

	Column {
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: boardRect.left;
		anchors.rightMargin: 20;

		spacing: 10;

		visible: !game.multiplayer && !mainMenu.visible;

		SubheadText {
			text: game.playerWhite ? tr("You're playing with white") : tr("You're playing with black");
		}

		SubheadText {
			text: game.easy ? tr("Low difficulty") : tr("High difficulty");
		}
	}

	SubheadText {
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: boardRect.left;
		anchors.rightMargin: 20;

		visible: game.multiplayer && !mainMenu.visible;

		text: game.playerWhite ? tr("White is moving") : tr("Black is moving");
	}

	TitleText {
		id: gameOver;

		anchors.centerIn: boardRect;

		focus: true;
		z: 1;
		style: Shadow;
		styleColor: "#333";
		text: game.whiteCounter == game.blackCounter ? tr("Draw") :
			game.multiplayer && game.whiteCounter > game.blackCounter ? tr("White won!") :
			game.multiplayer && game.whiteCounter < game.blackCounter ? tr("Black won!") :
			game.playerWhite && game.whiteCounter > game.blackCounter || !game.playerWhite && game.whiteCounter < game.blackCounter
			? tr("You won!")
			: tr("You lose");

		visible: game.over;

		Rectangle {
			anchors.fill: parent;
			anchors.margins: -20;

			color: "#000c";
		}

		onSelectPressed: { game.finishGame(); }
		onBackPressed: { game.finishGame(); }
		onVisibleChanged: {
			if (visible)
				this.setFocus();
		}
	}

	Rectangle {
		id: boardRect;

		width: 65hpw * 8;
		height: 65 * 8;

		anchors.centerIn: parent;

		visible: !mainMenu.visible;
		
		GridView {
			id: gameView;

			anchors.fill: parent;

			cellHeight: 65;
			cellWidth: 65hpw;
			orintation: GridView.Horizontal;

			model: ListModel { }
			delegate: CellDelegate { }
		}

		onSelectPressed: {
			if (game.multiplayer)
			{
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
			}
			else
			{
				if (aiMoveTimer.running) //ai is "thinking"
					return true;

				console.log("player moves into " + Math.floor(gameView.currentIndex / 8) + ", " + gameView.currentIndex % 8);
				var weight = engine.MakeMove(Math.floor(gameView.currentIndex / 8), gameView.currentIndex % 8, game.playerWhite, false);
				if (weight <= 0)
					return true;

				engine.WriteModel(gameView.model);
				game.update(game.playerWhite, weight);
				aiMoveTimer.start();
			}
		}

		onRedPressed: {
			if (game.multiplayer)
				return;

			if (aiMoveTimer.running) //ai is "thinking"
				return;

			var weight = engine.NextMove(game.playerWhite, false, gameView.model);
			game.update(game.playerWhite, weight);
			aiMoveTimer.start();
		}

		onGreenPressed: {
			if (game.multiplayer)
				return;

			game.playerWhite = true;
			game.startGame();
		}

		onYellowPressed: {
			if (game.multiplayer)
				return;

			game.playerWhite = false;
			game.startGame();
		}

		onBluePressed: {
			if (game.multiplayer)
				return;

			game.easy = !game.easy;
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

			BodyText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: tr("Help");
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2hpw;
				color: "#ff0000";
			}
		}

		Rectangle {
			id: green;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: red.right;

			BodyText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: tr("Start with white");
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2hpw;
				color: "#00ff00";
			}
		}

		Rectangle {
			id: yellow;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: green.right;

			BodyText {
				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: tr("Start with black");
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2hpw;
				color: "#ffff00";
			}
		}

		Rectangle {
			id: blue;

			width: parent.width / 4;
			height: parent.height;

			anchors.left: yellow.right;

			BodyText {
				id: difftext;

				anchors.centerIn: parent;
				anchors.bottomMargin: 10;

				text: game.easy ? tr("Hard") : tr("Easy");
			}

			Rectangle {
				height: 5;
				width: parent.width / 3;

				anchors.centerIn: parent;
				anchors.bottomMargin: -30;

				radius: 2hpw;
				color: "#0000ff";
			}
		}
	}

	onBackPressed: {
		if (mainMenu.visible)
			appManager.closeCurrentApp();
		else
			mainMenu.visible = true;
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

		if (!game.multiplayer && game.playerWhite)
			aiMoveTimer.start();
		else if (game.multiplayer)
			game.playerWhite = false;
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
