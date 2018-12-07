import "LevelDelegate.qml";
import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: levelRect;

	signal backToGame();
	signal levelChanged(level);

	color: colorTheme.backgroundColor;

	visible: false;

	SubheadText {
		y: 9;

		anchors.horizontalCenter: parent.horizontalCenter;

		text: tr("Выберите уровень");
		color: colorTheme.highlightPanelColor;
	}

	ListView {
		id: levelGrid;

		property int cellWidth: gameConsts.getGameWidth() / levelModel.count;
		property int cellHeight: 47;

		width: this.contentWidth;
		height: this.contentHeight;

		anchors.bottom: parent.bottom;

		focus: true;
		orientation: Horizontal;

		visible: true;

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

		onSelectPressed: { levelRect.levelChanged(levelGrid.currentIndex + 1); }

		onRightPressed: {
			if (levelGrid.currentIndex === levelModel.count - 1)
			{
				levelGrid.currentIndex = 0;
			}
			else
			{
				++levelGrid.currentIndex;
			}
		}

		onLeftPressed: {
			if (levelGrid.currentIndex === 0)
			{
				levelGrid.currentIndex = levelModel.count - 1;
			}
			else
			{
				--levelGrid.currentIndex;
			}
		}
	}

	function show() {
		levelRect.visible = true;
		levelGrid.currentIndex = 0;
		levelGrid.setFocus();
	}
}