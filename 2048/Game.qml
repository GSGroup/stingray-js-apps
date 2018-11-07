import "CellDelegate.qml";
import "MenuDelegate.qml";
import "engine.js" as engine;

Rectangle {
	id: game;
	anchors.centerIn: parent;
	height: safeArea.height;
	property int space: 6;
	property int cellSize:  (safeArea.height - space * 4) / 4;
	width: cellSize * 4 + space * 4;
	color: parent.color;
	focus: true;

	Rectangle {
		id: gridRect;
		radius: 10;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.margins: game.space;
		color: "#bcb0a2";
		height: parent.height;
		width: parent.width - game.space * 2;
		focus: true;

		Item {
			id: fieldView;
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}

			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}

			anchors.fill: parent;
			anchors.margins: game.space;
			focus: true;
			property int cellHeight:game.cellSize;
			property int cellWidth: game.cellSize;

			Timer {
				id: animTimer;

				interval: 800;

				onTriggered: { engine.next(fieldView.children); }
			}

			onCompleted: {
				for (var i = 16; i < 32; i ++) {
					this.children[i].value = 0;
					this.children[i].added = false;
					this.children[i].x = (i % 4) * this.cellWidth;
					this.children[i].y = Math.floor(i / 4 - 4) * this.cellHeight;
				}
				engine.init();
				this.draw();
			}

			onKeyPressed: {
	
				if (animTimer.running) 
					return true;

				if (key == "Select") {
//					backMenu.visible = true;
					backGrid.currentIndex = 0;
					backGrid.setFocus();
					backMenu.show();
					log("INDEX " + backGrid.currentIndex)
					return true;
				}

				engine.tic();
				switch (key) {
				case "Up": case "Down": case "Left": case "Right":
					var res = engine.turn(key);
					if (res.changed) engine.add();
					scoreText.val += res.sum;
					if (scoreText.val > bestText.val) {
						bestText.val = scoreText.val;
						save("best2048",scoreText.val);
					}
					if (!engine.check()) {
						restartMenu.visible = true;
						restartMenu.setFocus();
					}
					fieldView.draw();
					return true;
				}
			}

			function draw() {
				engine.changeCells(this.children, this.cellWidth, this.cellHeight);
				animTimer.restart();
			}
		}
	}

	direction: "Up";

	Rectangle {
		id: bestRect;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.bottomMargin: game.cellSize;
		anchors.leftMargin: game.space;
		height: game.cellSize / 1.5;
		radius: 10;
		width: Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);
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
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;
			property int val;
			text: val;
			font: bigFont;
			color: "#FFFFFF";

			onCompleted: {
				this.val = function() {
					var x;
					if (!(x = load("best2048"))) 
						return 0; 
					else 
						return x;
				}()
			}
		}
	}

	Rectangle {
		id: scoreRect;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.topMargin: game.cellSize;
		anchors.leftMargin: game.space;
		height: game.cellSize / 1.5;
		radius: 10;
		width: Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);
		color: "#CCC0B2";

		Text {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			text: tr("SCORE");
			color: "#EEE4DA";
			font: bigFont;
		}

		Text {
			id: scoreText;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;
			property int val: 0;
			text: val;
			font: bigFont;
			color: "#FFFFFF";
		}			
	}

	Rectangle {
		id: restartMenu;
		focus: true;
		visible: false;
		anchors.fill: parent;
		radius: 10;
		color: "#EEE4DAB0";

		Text {
			anchors.centerIn: parent;
			anchors.bottomMargin: game.cellSize / 2;
			font: bigFont;
			color: "#734A12";
			text: tr("GAME OVER");
		}

		Rectangle {
			anchors.centerIn: parent;
			anchors.topMargin: game.cellSize / 2;
			color: "#734A12";
			radius: 10;
			width: game.cellSize;
			height: game.cellSize / 2;

			Text {
				anchors.centerIn: parent;
				font: smallFont;
				color: "#FFFFFF";
				text: tr("Try again");
			}
		}

		onSelectPressed: {
			restartMenu.visible = false;
			engine.clear();
			fieldView.draw();
			fieldView.setFocus();
			scoreText.val = 0;
		}
	}

	Rectangle {
		id: backMenu;
		visible: false;
		focus: true;
//		anchors.fill: parent;
		anchors.centerIn: parent;
		height: parent.height;
		radius: 10;
		color: "#EEE4DAB0";
		width: 0;
		clip: true;
		Behavior on width { animation: Animation { duration: 300; } }

		ListView {
			id: backGrid;
			focus: true;
			visible: parent.width > 0;
			property int cellHeight: game.cellSize;
			property int cellWidth: game.cellSize * 2;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.cellSize / 2;
			height: game.cellSize * 4;
			width: game.cellSize;
			model: ListModel {
				ListElement {text: "Continue"}
				ListElement {text: "New game"}
				ListElement {text: "Help"}
			}
			delegate: MenuDelegate{}

			onSelectPressed: {
				switch (backGrid.currentIndex) {
				case 0: 
					backMenu.width = 0;
					fieldView.setFocus();
					break;
				case 1:
					engine.clear();
					fieldView.setFocus();
					fieldView.draw();
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
			color: "#6D654E";
			visible: false;
			focus: true;
			wrapMode: Text.Wrap;
			text: tr("Use your arrow keys to move the tiles. When two tiles with the same number touch, they merge into one!");

			onSelectPressed: {
				this.visible = false;
				backGrid.visible = true;
//				backGrid.setFocus();
				backMenu.show();
			}
		}

		function show() {
			this.visible = true;
			this.width = game.width;
			this.setFocus();
		}
	}
	
//	onBackPressed: {
//		backMenu.width = backMenu.width == 0 ? game.width : 0;
//		backGrid.visible = !backGrid.visible;
//		backGrid.currentIndex = 0;
//	}
}
