Item {
	width: parent.cellWidth;
	height: parent.cellHeight;
	anchors.horizontalCenter: parent.horizontalCenter;
	Rectangle {
		anchors.centerIn: parent;
		color: parent.activeFocus ? "#835A22FF" : "#734A12AA";
		radius: 10;
		width: parent.width;
		height: parent.height / 2;
		Text {
			anchors.centerIn: parent;
			font: bigFont;
			color: "#FFFFFF";
			text: model.text;
		}
	}
}
