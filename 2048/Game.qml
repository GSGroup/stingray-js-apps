import "CellDelegate.qml";
import "MenuDelegate.qml";
import "engine.js" as engine;

Rectangle {
	id: game;

	property int space: 6;
	property int cellSize:  (safeArea.height - space * 4) / 4;

	width: cellSize * 4 + space * 4;
	height: safeArea.height;

	anchors.centerIn: parent;

	color: parent.color;
	focus: true;

	Rectangle {
		id: gridRect;

		width: parent.width - game.space * 2;
		height: parent.height;

		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.margins: game.space;

		radius: 10;
		color: "#bcb0a2";
		focus: true;

		Item {
			id: fieldView;

			property int cellHeight: game.cellSize;
			property int cellWidth: game.cellSize;

			anchors.fill: parent;
			anchors.margins: game.space;

			focus: true;

			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }

			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }
			CellDelegate { } CellDelegate { } CellDelegate { } CellDelegate { }

			Timer {
				id: animTimer;

				interval: 550;
			}

			onCompleted: {
				for (var i = 16; i < 32; ++i)
				{
					this.children[i].value = 0;
					this.children[i].added = false;
					this.children[i].x = (i % 4) * this.cellWidth;
					this.children[i].y = Math.floor(i / 4 - 4) * this.cellHeight;
				}

				engine.init();
				engine.changeCells(this.children, this.cellWidth, this.cellHeight);
			}

			onKeyPressed: {
				if (animTimer.running)
					return true;

				if (key == "Select")
				{
					backGrid.currentIndex = 0;
					backGrid.setFocus();
					backMenu.show();
					return true;
				}

				if (key == "Up" || key == "Down" || key == "Left" || key == "Right")
				{
					fieldView.makeMove(key);
					return true;
				}
			}

			function makeMove(direction) {
				var res = engine.move(direction);

				scoreText.val += res.sum;

				if (scoreText.val > bestText.val)
				{
					bestText.val = scoreText.val;
					save("best2048", scoreText.val);
				}

				engine.changeCells(this.children, this.cellWidth, this.cellHeight);

				if (!engine.check())
				{
					restartMenu.visible = true;
					restartMenu.setFocus();
					restartMenu.message = tr("Game over");
					return;
				}

				if (res.win)
				{
					restartMenu.visible = true;
					restartMenu.setFocus();
					restartMenu.message = tr("You win!");

				}
				else
				{
					animTimer.restart();
				}
			}
		}
	}

	Rectangle {
		id: bestRect;

		width: Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);
		height: game.cellSize / 1.5;

		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.bottomMargin: game.cellSize;
		anchors.leftMargin: game.space;

		radius: 10;
		color: "#CCC0B2";

		Text {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.space;

			text: tr("BEST");
			color: "#EEE4DA";
			font: bigFont;
		}

		Text {
			id: bestText;

			property int val;

			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;

			text: val;
			font: bigFont;
			color: "#FFFFFF";

			onCompleted: {
				if (!(this.val = load("best2048")))
					this.val = 0;
			}
		}
	}

	Rectangle {
		id: scoreRect;

		width: Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);
		height: game.cellSize / 1.5;

		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.topMargin: game.cellSize;
		anchors.leftMargin: game.space;

		radius: 10;
		color: "#ccc0b2";

		Text {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.space;

			text: tr("SCORE");
			color: "#eee4da";
			font: bigFont;
		}

		Text {
			id: scoreText;

			property int val: 0;

			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;

			text: val;
			font: bigFont;
			color: "#ffffff";
		}			
	}

	Rectangle {
		id: restartMenu;

		property string message;

		anchors.fill: parent;

		focus: true;
		radius: 10;
		color: "#eee4dab0";

		visible: false;

		Text {
			anchors.centerIn: parent;
			anchors.bottomMargin: game.cellSize / 2;

			font: bigFont;
			color: "#734a12";
			text: restartMenu.message;
		}

		Rectangle {
			width: game.cellSize;
			height: game.cellSize / 2;
			anchors.centerIn: parent;
			anchors.topMargin: game.cellSize / 2;

			color: "#734a12";
			radius: 10;

			Text {
				anchors.centerIn: parent;

				font: smallFont;
				color: "#ffffff";
				text: tr("Try again");
			}
		}

		onSelectPressed: {
			restartMenu.visible = false;
			engine.clear();
			engine.changeCells(fieldView.children, fieldView.cellWidth, fieldView.cellHeight);
			fieldView.setFocus();
			scoreText.val = 0;
		}
	}

	Rectangle {
		id: backMenu;

		width: 0;
		height: parent.height;
		anchors.centerIn: parent;

		radius: 10;
		color: "#eee4dab0";
		clip: true;
		focus: true;

		visible: false;

		Behavior on width { animation: Animation { duration: 300; } }

		ListView {
			id: backGrid;

			property int cellHeight: game.cellSize;
			property int cellWidth: game.cellSize * 2;

			width: game.cellSize;
			height: game.cellSize * 4;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.cellSize / 2;

			focus: true;

			visible: parent.width > 0;

			model: ListModel {
				ListElement { text: "Continue" }
				ListElement { text: "New game" }
				ListElement { text: "Help" }
			}
			delegate: MenuDelegate { }

			onSelectPressed: {
				switch (backGrid.currentIndex)
				{
					case 0:
						backMenu.width = 0;
						fieldView.setFocus();
						break;
					case 1:
						engine.clear();
						fieldView.setFocus();
						engine.changeCells(fieldView.children, fieldView.cellWidth, fieldView.cellHeight);
						scoreText.val = 0;
						backMenu.width = 0;
						break;
					case 2:
						help.visible = true;
						help.setFocus();
						backGrid.visible = false;
						return true;
				}
			}
		}

		BigText {
			id: help;

			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.margins: game.space * 10;

			horizontalAlignment: Text.AlignHCenter;
			color: "#6d654e";
			focus: true;
			wrapMode: Text.Wrap;
			text: tr("Use your arrow keys to move the tiles. When two tiles with the same number touch, they merge into one!");

			visible: false;

			onSelectPressed: {
				this.visible = false;
				backGrid.visible = true;
				backMenu.show();
			}
		}

		function show() {
			this.visible = true;
			this.width = game.width;
			this.setFocus();
		}
	}
}
