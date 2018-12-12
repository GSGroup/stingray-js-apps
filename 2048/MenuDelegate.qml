Item {
	width: parent.cellWidth;
	height: parent.cellHeight;

	anchors.horizontalCenter: parent.horizontalCenter;

	focus: true;

	Rectangle {
		width: parent.width;
		height: parent.height / 2;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#835a22ff" : "#734a12aa";
		radius: 10;

		Text {
			anchors.centerIn: parent;

			font: bigFont;
			color: "#ffffff";
			text: model.text;
		}
	}
}
