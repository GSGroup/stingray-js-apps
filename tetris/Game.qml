import "MenuDelegate.qml";

Rectangle {
	id: game;

	property int space: 6;
	property int cellSize: (safeArea.height - space * 4) / 20;
	property int infoMarginSize: space * 6;
	property int infoSize: cellSize * 6;

	width: cellSize * 10;
	height: safeArea.height - space * 4;

	anchors.centerIn: parent;

	color: "#292929";
	focus: true;
	radius: 5;

	Rectangle {
		id: nextBlockRect;

		width: game.cellSize*6;
		height: game.infoSize;

		anchors.top: parent.top;
		anchors.left:parent.right;
		anchors.bottomMargin: game.space;
		anchors.leftMargin: game.infoMarginSize;

		color:"#000000";
		radius: 5;

		Text {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			anchors.leftMargin: game.space;

			text: qsTr("Далее");
			color: "#FFFFFF";
			font: smallFont;

		}
	}

	Rectangle {
		id: levelRect;

		width: game.infoSize;
		height:game.cellSize*2;

		anchors.left: parent.right;
		anchors.topMargin: game.space;
		anchors.leftMargin: game.infoMarginSize;
		anchors.top:nextBlockRect.bottom;

		color: "#000000";
		radius: 5;

		Text {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			anchors.leftMargin: game.space;

			text: qsTr("Уровень   ");
			color: "#FFFFFF";
			font: smallFont;
		}
	}

	Rectangle {
		id: scoreRect;

		height: game.cellSize*2;
		width:game.infoSize;

		anchors.left: parent.right;
		anchors.top:levelRect.bottom;
		anchors.topMargin: game.space;
		anchors.leftMargin: game.infoMarginSize;

		color: "#000000";
		radius: 5;

		Text {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			anchors.leftMargin: game.space;

			text: qsTr("Счет      ");
			color: "#FFFFFF";
			font: smallFont;
		}
	}

	Rectangle {
		id: backMenu;

		width: 0;
		height: game.cellSize * 8;

		anchors.centerIn: parent;

		focus: false;
		color: parent.color;
		radius: 5;
		clip: true;

		visible: false;
		opacity: 0.7;

		Behavior on width { animation: Animation { duration: 300; } }

		ListView {
			id: backGrid;

			property int cellWidth: game.cellSize * 6;
			property int cellHeight: game.cellSize * 8;

			width: game.cellSize * 6;
			height: game.cellSize * 8;

			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;

			focus: true;
			//clip: true;

			visible: parent.width > 0;

			model: ListModel {
				ListElement {text: "Продолжить"}
				ListElement {text: "Новая игра"}
				ListElement {text: "Помощь"}
			}

			delegate: MenuDelegate{}

			onSelectPressed: {
				switch (backGrid.currentIndex) {
				case 0:
					backMenu.width = 0;
					backMenu.focus = false;
					backMenu.visible = false;
					break;
				case 1:
					backMenu.width = 0;
					backMenu.focus = false;
					backMenu.visible = false;
					break;
				case 2:
					help.visible = true;
					help.focus = true;
					backGrid.visible = false;
					return true;
				}
			}

				onKeyPressed: {
					if (key == "8") {
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

			color: "#FFFFFF";
			focus: false;
			text: qsTr ("Use your arrow keys to move the Tetriminos (game pieces). The aim is to create a horizontal line of ten units without gaps" +
						" by moving Tetriminos and rotating it by 90 degree. When such a line is created, it gets destroyed and any block above the" +
						" deleted line will fall.");
			font: smallFont;

			visible: false;

			wrapMode: Text.Wrap;

			onKeyPressed: {
				if (key == "Select") {
					this.visible = false;
					this.focus = false;
					backGrid.visible = true;
					return true;
				}
			}
		}

		function show() {
			this.currentIndex = 0;
			this.width = game.width * 2;
			this.focus = true;
			this.visible = true;

		}

	}

	Rectangle {
		id: pauseRect;

		width: game.width;
		height: game.cellSize * 6 + game.space * 4;

		anchors.centerIn: parent;

		focus: true;
		color: parent.color;
		radius: 5;

		visible: false;
		opacity: 1.0;

		Text {
			anchors.centerIn: parent;

			text: qsTr("Пауза");
			color: "#FFFFFF";
			font: smallFont;

		}

		function show() {
			this.visible = true;
			this.focus = true;
		}

		onKeyPressed: {
			if (key == "8") {
				this.visible = false;
				this.focus   = false;

				return true;
			}

			if (key == "Select") {
				return true;
			}
		}

	}

	onKeyPressed: {
		if (key == "Select") {
			backMenu.show();
			return true;
		}

		if (key == "8") {
			pauseRect.show();
			return true;
		}
	}

}
