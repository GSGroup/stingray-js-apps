import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: levelRect;

	focus: true;
	color: colorTheme.backgroundColor;
	clip: true;

	visible: false;

	SmallCaptionText {
		y: 9;

		anchors.horizontalCenter: parent.horizontalCenter;

		text: qsTr("Выберите уровень");
		color: colorTheme.highlightPanelColor;
	}

	ListView {
		id: levelGrid;

		property int cellWidth: gameConsts.getGameWidth() / levelModel.count;
		property int cellHeight: gameConsts.getBlockSize() * 1.5;

		width: this.contentWidth;
		height: this.contentHeight;

		anchors.bottom: parent.bottom;

		focus: true;
		orientation: Horizontal;

		visible: true;

		model: ListModel {
			id:levelModel;

			ListElement { text: "1" }
			ListElement { text: "2" }
			ListElement { text: "3" }
			ListElement { text: "4" }
			ListElement { text: "5" }
			ListElement { text: "6" }
			ListElement { text: "7" }
			ListElement { text: "8" }
			ListElement { text: "9" }
			ListElement { text: "10" }
		}
		delegate: LevelDelegate { }

		onSelectPressed: {
			levelRect.visible = false;
		}

		onKeyPressed: {
			if (key === "8" || key === "6") {
				return true;
			}
		}
	}

	function show() {
		levelRect.visible = true;
		levelGrid.currentIndex = 0;
		levelGrid.setFocus();
	}
}
