Rectangle {
	id: levelMenu;

	Text {
		y: 9;

		anchors.horizontalCenter: parent.horizontalCenter;

		text: qsTr("Выберите уровень");
		color: colorTheme.highlightPanelColor;
		font: captionSmall;
	}

	ListView {
		id: levelGrid;

		property int cellWidth: game.width / levelModel.count;
		property int cellHeight: game.blockSize * 1.5;

		width: game.width;
		height: cellHeight;

		anchors.bottom: parent.bottom;

		focus: true;
		orientation: Horizontal;

		visible: parent.width > 0;

		model: ListModel {
			id:levelModel;

			ListElement {text: "1"}
			ListElement {text: "2"}
			ListElement {text: "3"}
			ListElement {text: "4"}
			ListElement {text: "5"}
			ListElement {text: "6"}
			ListElement {text: "7"}
			ListElement {text: "8"}
			ListElement {text: "9"}
			ListElement {text: "10"}
		}

		delegate: LevelDelegate { }

		onSelectPressed: {
			levelMenu.width = 0;
			levelMenu.visible = false;

			movingTetraminos.setFocus();
			animTimer.start();
		}

		onKeyPressed: {
			if (key === "8" || key === "6") {
				return true;
			}
		}
	}
}
