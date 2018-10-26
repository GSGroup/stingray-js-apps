Item {
	height: 90;

	Rectangle {
		width: parent.width;
		height: parent.height - 25;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#115511" : "#4c744c";

		radius: 10;

		BigText {
			anchors.centerIn: parent;

			text: qsTr(model.text);
			color: "#000";
		}
	}
}
