Item {
	height: 90;

	focus: true;

	Rectangle {
		width: parent.width;
		height: parent.height - 25;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#115511" : "#4c744c";

		radius: 10;

		TitleText {
			anchors.centerIn: parent;

			text: tr(model.text);
			color: "#000";
		}
	}
}
