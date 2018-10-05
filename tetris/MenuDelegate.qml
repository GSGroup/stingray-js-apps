Item {
	width: parent.cellWidth;
	height: parent.cellHeight / 3;

	anchors.horizontalCenter: parent.horizontalCenter;

	Rectangle {

		width: parent.width;
		height: parent.height / 2;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#ADADAD":"#525252";
		radius: 10;

		Text {
			anchors.centerIn: parent;

			font: smallFont;
			color: "#FFFFFF";
			text: model.text;
		}
	}
}

