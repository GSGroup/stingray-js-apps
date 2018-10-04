Item {
	width: parent.cellWidth;
	height: parent.cellHeight;

	anchors.horizontalCenter: parent.horizontalCenter;

	Rectangle {

		width: parent.width;
		height: parent.height / 2;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#ADADAD":"#949494";
		radius: 10;

		Text {
			anchors.centerIn: parent;

			font: smallFont;
			color: "#FFFFFF";
			text: model.text;
		}
	}
}

