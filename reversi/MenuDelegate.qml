Item {
	width: 390;
	height: 90;

	anchors.horizontalCenter: parent.horizontalCenter;

	Rectangle {
		width: parent.width;
		height: parent.height - 25;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#115511" : "#4c744c";

		radius: 10;

		Text {
			anchors.centerIn: parent;

			font: bigFont;
			text: qsTr(model.text);
		}
	}
}
